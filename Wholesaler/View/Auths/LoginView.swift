//
//  LoginView.swift
//  Wholeseller
//
//  Created by CHANDAN on 17/06/25.
//

import SwiftUI
import CoreHaptics
import AuthenticationServices
import FirebaseAuth
import Firebase
import Foundation
import GoogleSignIn

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var navigateToHome = false
    @State private var navigateToSignUp = false
    @State private var shakeEmailField = false
    @State private var userUID: String? = nil
    @State private var guestSessionStartTime: Date? = nil
    @State private var isGuestSessionExpired = false
    @State private var isLoggingIn = false
    @State var authResult: FirebaseAuth.User?
    @State private var isGoogleLoading = false
    @State private var isAppleLoading = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authVM: AuthViewModel
    private let appleSignInHandler: AppleSignInHandler
    
    init() {
        let handler = AppleSignInHandler()
        self.appleSignInHandler = handler
    }
    
    func handleAppleSignIn() {
        isAppleLoading = true
        
        // Create a DispatchWorkItem to allow cancelling the fallback
        let fallbackWorkItem = DispatchWorkItem {
            if self.isAppleLoading {
                self.isAppleLoading = false
            }
        }
        
        DispatchQueue.main.async {
            self.appleSignInHandler.startSignInWithAppleFlow()
        }
        
        // Schedule fallback timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: fallbackWorkItem)
        
        // Cancel fallback if AppleSignInHandler completes early
        appleSignInHandler.onSignInSuccess = { user in
            fallbackWorkItem.cancel()
            DispatchQueue.main.async {
                var currentUser = User(
                    uid: user.uid,
                    email: user.email ?? "",
                    fullName: user.displayName ?? "No Name"
                )
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(user.uid)
                userRef.getDocument { document, error in
                    if let document = document, document.exists {
                        if let fetchedFullName = document.get("fullName") as? String {
                            currentUser.fullName = fetchedFullName
                        }
                        self.authVM.currentUser = currentUser
                    } else {
                        let userData: [String: Any] = [
                            "fullName": user.displayName ?? "No Name",
                            "email": user.email ?? "No Email",
                            "uid": user.uid
                        ]
                        userRef.setData(userData)
                        self.authVM.currentUser = currentUser
                    }
                    self.authResult = user
                    self.isAppleLoading = false
                    self.navigateToHome = true
                }
            }
        }
        
        appleSignInHandler.onSignInFailure = { error in
            fallbackWorkItem.cancel()
            DispatchQueue.main.async {
                self.isAppleLoading = false
                self.alertMessage = "Apple Sign-In failed: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
    
    private func setupAppleSignIn() {
        // No-op: Apple Sign-In handlers are now set in handleAppleSignIn
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                contentView
            }
        }
        .onAppear {
            setupAppleSignIn()
        }
    }
    
    private var logoSection: some View {
        Image(colorScheme == .dark ? "AppLogo-Dark" : "AppLogo-Light")
            .resizable()
            .frame(maxWidth: .infinity)
            .scaledToFit()
            .padding(.bottom, -70)
            .offset(y: -20)
    }
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            TextField("Enter your email", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                .modifier(Shake(animatableData: CGFloat(shakeEmailField ? 1 : 0)))
        }
        .padding(.bottom, 10)
    }
    
    private var passwordField: some View {
        HStack {
            Group {
                if isSecure {
                    SecureField("Password", text: $password)
                } else {
                    TextField("Password", text: $password)
                }
            }
            .padding(.trailing, 32)
            
            Button(action: {
                isSecure.toggle()
            }) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 10)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
    
    private var continueButton: some View {
        Button(action: {
            let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedEmail.isEmpty {
                withAnimation(.default) {
                    shakeEmailField.toggle()
                }
            } else if !isValidEmail(trimmedEmail) {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                alertMessage = "Please enter a valid email"
                showAlert = true
            } else {
                isLoggingIn = true
                Task {
                    let result = await authVM.login(email: email, password: password)
                    switch result {
                        case .success(let user):
                            self.authResult = user
                            self.navigateToHome = true
                            self.isLoggingIn = false
                        case .failure(let error as NSError):
                            let errorCode = AuthErrorCode(rawValue: error.code)
                            var message = ""
                            switch errorCode {
                                case .wrongPassword:
                                    message = "The password is incorrect. Please try again."
                                case .userNotFound:
                                    message = "No account found with this email. Please sign up first."
                                case .invalidEmail:
                                    message = "The email address is badly formatted."
                                case .internalError:
                                    message = "Something went wrong on our side. Please try again."
                                default:
                                    message = "Unexpected error: \(error.localizedDescription)"
                            }
                            alertMessage = "Login failed: \(message)"
                            showAlert = true
                            isLoggingIn = false
                    }
                }
            }
        }) {
            if isLoggingIn {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(colorScheme == .dark ? Color(hex: "#a31aed") : Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            } else {
                Text("Login")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(colorScheme == .dark ? Color(hex: "#FFC107") : Color.black)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
        .disabled(isLoggingIn)
    }
    
    private var forgotPasswordButton: some View {
        HStack {
            Spacer()
            Button(action: {
                if isValidEmail(email) {
                    Task {
                        do {
                            try await authVM.resetPassword(by: email)
                            alertMessage = "Password reset email sent!"
                            showAlert = true
                        } catch {
                            alertMessage = "Failed to send reset email: \(error.localizedDescription)"
                            showAlert = true
                        }
                    }
                } else {
                    alertMessage = "Please enter a valid email first."
                    showAlert = true
                }
            }) {
                Text("Forgot password?")
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .padding(.bottom,10)
            }
        }
        .padding(.horizontal)
    }
    
    private var socialLoginButtons: some View {
        HStack(spacing: 20) {
            Button(action: {
                isGoogleLoading = true // Start loading animation
                Task {
                    guard let clientID = FirebaseApp.app()?.options.clientID else {
                        isGoogleLoading = false
                        return
                    }
                    let config = GIDConfiguration(clientID: clientID)
                    guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
                        isGoogleLoading = false
                        return
                    }
                    GIDSignIn.sharedInstance.configuration = config
                    GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                        if let error = error {
                            DispatchQueue.main.async {
                                isGoogleLoading = false
                                alertMessage = "Google Sign-In failed: \(error.localizedDescription)"
                                showAlert = true
                            }
                            return
                        }
                        guard
                            let googleUser = result?.user,
                            let idToken = googleUser.idToken?.tokenString
                        else {
                            DispatchQueue.main.async {
                                isGoogleLoading = false
                                alertMessage = "Failed to get Google user data"
                                showAlert = true
                            }
                            return
                        }
                        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: googleUser.accessToken.tokenString)
                        Task {
                            do {
                                // Sign in with Google credential in Firebase
                                let authResult = try await Auth.auth().signIn(with: credential)
                                
                                // Immediately update authVM.currentUser with custom User model
                                authVM.currentUser = User(
                                    uid: authResult.user.uid,
                                    email: authResult.user.email ?? "",
                                    fullName: authResult.user.displayName ?? "No Name"
                                )
                                
                                // Now update Firestore if needed
                                let db = Firestore.firestore()
                                let userRef = db.collection("users").document(authResult.user.uid)
                                userRef.getDocument { document, error in
                                    if let document = document, document.exists {
                                        // User data exists, update the ViewModel if not already populated
                                        if let fetchedFullName = document.get("fullName") as? String {
                                            authVM.currentUser?.fullName = fetchedFullName
                                        }
                                        if let fetchedEmail = document.get("email") as? String {
                                            authVM.currentUser?.email = fetchedEmail
                                        }
                                    } else {
                                        // If the data doesn't exist, save it
                                        let userData: [String: Any] = [
                                            "fullName": googleUser.profile?.name ?? "No Name",
                                            "email": googleUser.profile?.email ?? "No Email",
                                            "uid": authResult.user.uid
                                        ]
                                        userRef.setData(userData)
                                    }
                                    
                                    // Now proceed to the next step - make sure this is inside the completion handler
                                    DispatchQueue.main.async {
                                        self.authResult = authResult.user
                                        self.isGoogleLoading = false
                                        self.navigateToHome = true
                                    }
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    isGoogleLoading = false
                                    alertMessage = "Firebase SignIn failed: \(error.localizedDescription)"
                                    showAlert = true
                                }
                            }
                        }
                    }
                }
            }) {
                if isGoogleLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .dark ? .white : .black))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                } else {
                    HStack {
                        Image("google-logo")
                            .resizable()
                            .frame(width: 20,height: 20)
                            .scaledToFill()
                        
                        Text("Google")
                            .font(.custom("Poppins-SemiBold", size: 14))
                            .foregroundColor(colorScheme == .dark ? .blue : .black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            
            Button(action: {
                handleAppleSignIn()
            }) {
                if isAppleLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .dark ? .white : .black))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                } else {
                    HStack {
                        Image(systemName: "apple.logo")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Text("Apple")
                            .font(.custom("Poppins-SemiBold", size: 14))
                            .foregroundColor(colorScheme == .dark ? .blue : .black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    private var contentView: some View {
        VStack(spacing: 8) {
            logoSection
                .padding(.bottom, -10)
            Text("Login or Signup")
                .font(.title2)
                .bold()
                .padding(.top, -10)
            
            emailField
            passwordField
            continueButton
            forgotPasswordButton
            
            HStack {
                VStack { Divider() }.padding(.horizontal, 20)
                Text("or")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                VStack { Divider() }.padding(.horizontal, 20)
            }
            .padding(.vertical, 0)
            
            socialLoginButtons
            
            Spacer(minLength: 30)
            
            HStack(spacing: 4) {
                Text("Do not have an account?")
                    .foregroundColor(.gray)
                Button(action: {
                    navigateToSignUp = true
                }) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 20)
            
            Spacer(minLength: 20)
            Text("Version 1.0.0")
                .font(.custom("OpenSauceSans-Black", size: 10))
                .font(.footnote)
                .padding(.bottom, 10)
        }
        .padding()
        .padding(.top, -30) // moves everything slightly up
        .navigationTitle("")
        .navigationBarHidden(true)
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
        .navigationDestination(isPresented: $navigateToSignUp) {
            SignUpView().navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $navigateToHome) {
            HomeView()
                .navigationBarBackButtonHidden(true)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
