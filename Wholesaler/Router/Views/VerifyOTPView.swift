////
////  VerifyOTPView.swift
////  Wholeseller
////
////  Created by CHANDAN on 18/06/25.
////
//
//import SwiftUI
//import Auth0
//import FirebaseAuth
//import Firebase
//
//struct VerifyOTPView: View {
//    var email: String
//    
//    @State private var otpCode = ""
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    @State private var navigateToHome = false
//    @State private var isLoading = false
//    @State private var canResend = false
//    @State private var resendTimer = 30
//    var authResult: FirebaseAuth.User?
//    @EnvironmentObject var authVM: AuthViewModel
//    var body: some View {
//        VStack(spacing: 24) {
//            Text("Enter the 6-digit code sent to")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            
//            Text(email)
//                .font(.headline)
//                .foregroundColor(.primary)
//            
//            TextField("Enter OTP", text: $otpCode)
//                .keyboardType(.numberPad)
//                .textContentType(.oneTimeCode)
//                .multilineTextAlignment(.center)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(12)
//                .frame(width: 200)
//                .onChange(of: otpCode) { newValue in
//                    otpCode = String(newValue.prefix(6).filter { "0123456789".contains($0) })
//                }
//
//            if isLoading {
//                ProgressView("Verifying...")
//                    .progressViewStyle(CircularProgressViewStyle())
//            }
//
//            Button(action: {
//                verifyOTP()
//            }) {
//                Text("Verify OTP")
//                    .fontWeight(.bold)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .foregroundColor(.white)
//            }
//            .background(
//                (otpCode.count == 6 && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: otpCode))) ?
//                Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 163/255, green: 26/255, blue: 237/255, alpha: 1) : UIColor.black }) :
//                Color.gray.opacity(0.4)
//            )
//            .cornerRadius(12)
//            .padding(.horizontal)
//            .disabled(isLoading || otpCode.count != 6 || !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: otpCode)))
//
//            if canResend {
//                Button("Resend OTP") {
//                    resendOTP()
//                }
//                .foregroundColor(.blue)
//                .padding(.top)
//            } else {
//                Text("Resend available in \(resendTimer)s")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//
//            NavigationStack {
//                NavigationLink(value: "home") {
//                    EmptyView()
//                }
//                .navigationDestination(isPresented: $navigateToHome) {
//                    HomeView()
//                        .navigationBarBackButtonHidden(true)
//                }
//            }
//        }
//        .environmentObject(AuthViewModel())
//        .padding()
//        .navigationTitle("Verify OTP")
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//        }
//        .onAppear {
//            startResendCountdown()
//        }
//    }
//
//    func verifyOTP() {
//        isLoading = true
//        Auth0
//            .authentication()
//            .login(email: email, code: otpCode, audience: nil, scope: "openid profile email")
//            .start { result in
//                DispatchQueue.main.async {
//                    isLoading = false
//                    switch result {
//                    case .success(_):
//                        navigateToHome = true
//                        authVM.userSession = authResult
//                    case .failure(let error):
//                        alertMessage = "Verification failed: \(error.localizedDescription)"
//                        showAlert = true
//                    }
//                }
//            }
//    }
//    
//    func startResendCountdown() {
//        canResend = false
//        resendTimer = 30
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//            resendTimer -= 1
//            if resendTimer <= 0 {
//                timer.invalidate()
//                canResend = true
//            }
//        }
//    }
//
//    func resendOTP() {
//        startResendCountdown()
//        isLoading = true
//        Auth0
//            .authentication()
//            .startPasswordless(email: email, type: .code, connection: "email")
//            .start { result in
//                isLoading = false
//                switch result {
//                case .success:
//                    alertMessage = "A new OTP has been sent to your email."
//                    showAlert = true
//                case .failure(let error):
//                    alertMessage = "Failed to resend OTP: \(error.localizedDescription)"
//                    showAlert = true
//                }
//            }
//    }
//}
//
//#Preview {
//    VerifyOTPView(email: "demo@demo.com")
//}
