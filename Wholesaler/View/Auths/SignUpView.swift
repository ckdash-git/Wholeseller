import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var acceptedTerms = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = "Error"
    @State private var isSecurePassword = true
    @State private var isSecureConfirmPassword = true
    @State private var isLoading = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @StateObject private var authVM = AuthViewModel()
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func validateForm() -> Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alertMessage = "Please enter your name"
            showAlert = true
            return false
        }
        
        if !isValidEmail(email) {
            alertMessage = "Please enter a valid email"
            showAlert = true
            return false
        }
        
        if password.count < 6 {
            alertMessage = "Password must be at least 6 characters"
            showAlert = true
            return false
        }
        
        if password != confirmPassword {
            alertMessage = "Passwords do not match"
            showAlert = true
            return false
        }
        
        guard acceptedTerms else {
            alertMessage = "Please accept the terms and conditions"
            showAlert = true
            return false
        }
        
        return true
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
                VStack(spacing: 20) {
                    Image("signup")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                        .frame(maxWidth: 300)
                        .padding(.top, 20)
                    
                    Text("Let's Unwrap the Optional!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Please register to login.")
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    ScrollView {
                        formFields
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    @ViewBuilder
    private var formFields: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .disableAutocorrection(true)
                    .autocorrectionDisabled(true)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .disableAutocorrection(true)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Group {
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    Group {
                        if isSecurePassword {
                            SecureField("Password", text: $password)
                                .disableAutocorrection(true)
                                .autocorrectionDisabled(true)
                        } else {
                            TextField("Password", text: $password)
                                .disableAutocorrection(true)
                                .autocorrectionDisabled(true)
                        }
                    }
                    Button(action: { isSecurePassword.toggle() }) {
                        Image(systemName: isSecurePassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    Group {
                        if isSecureConfirmPassword {
                            SecureField("Confirm Password", text: $confirmPassword)
                                .disableAutocorrection(true)
                                .autocorrectionDisabled(true)
                        } else {
                            TextField("Confirm Password", text: $confirmPassword)
                                .disableAutocorrection(true)
                                .autocorrectionDisabled(true)
                        }
                    }
                    Button(action: { isSecureConfirmPassword.toggle() }) {
                        Image(systemName: isSecureConfirmPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
            HStack {
                Button(action: { acceptedTerms.toggle() }) {
                    Image(systemName: acceptedTerms ? "checkmark.square.fill" : "square")
                        .foregroundColor(acceptedTerms ? .blue : .gray)
                }
                Text("I accept the ")
                NavigationLink("Terms and Conditions", destination: TermsConditionsView())
                    .foregroundColor(.blue)
            }
            
            Button(action: {
                if validateForm() {
                    withAnimation {
                        isLoading = true
                    }
                    Task {
                        do {
                            let emailExists = await authVM.checkIfEmailExists(email: email)
                            if emailExists {
                                alertTitle = "Error"
                                alertMessage = "Email already exists. Please use a different email or sign in."
                                showAlert = true
                                await MainActor.run {
                                    isLoading = false
                                }
                                return
                            }
                            
                            let result = try await Auth.auth().createUser(withEmail: email, password: password)
                            try await result.user.sendEmailVerification()
                            await authVM.createUser(uid: result.user.uid, email: email, fullName: name)
                            alertTitle = "Success"
                            alertMessage = "Signup successful! A verification email has been sent to \(email)."
                            showAlert = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    isLoading = false
                                }
                                dismiss()
                            }
                        } catch let error as NSError {
                            let errorCode = AuthErrorCode(rawValue: error.code)
                            var message = ""

                            switch errorCode {
                            case .emailAlreadyInUse:
                                message = "The email address is already in use by another account."
                            case .weakPassword:
                                message = "Password should be at least 6 characters."
                            case .invalidEmail:
                                message = "The email address is badly formatted."
                            default:
                                message = error.localizedDescription
                            }

                            await MainActor.run {
                                alertTitle = "Error"
                                alertMessage = message
                                showAlert = true
                                isLoading = false
                            }
                        }
                    }
                }
            }) {
                Group {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(colorScheme == .dark ? Color(hex: "#a31aed") : .black)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .disabled(isLoading)
            
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                Button(action: { dismiss() }) {
                    Text("Sign In")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    SignUpView()
}
