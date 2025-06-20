//
//  MyAccountView.swift
//  Wholeseller
//
//  Created by CHANDAN on 19/06/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct MyAccountView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss

    @State private var fullName: String = ""
    @State private var email: String = ""

    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""

    @State private var isSaving = false
    @State private var showSavedAlert = false
    @State private var errorMessage: String?
    
    @State private var canEditFullName = false
    @State private var canEditEmail = false
    @State private var showEditFullNameAlert = false
    @State private var showEditEmailAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Information"), footer: Text("Changes to email require password confirmation.")) {
                    HStack {
                        TextField("Full Name", text: $fullName)
                            .disabled(!canEditFullName)
                        Button(action: {
                            showEditFullNameAlert = true
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.gray)
                        }
                        .alert("Edit Full Name", isPresented: $showEditFullNameAlert) {
                            Button("Cancel", role: .cancel) {}
                            Button("Continue") {
                                canEditFullName = true
                            }
                        } message: {
                            Text("You are going to modify your full name.")
                        }
                    }
                    .autocapitalization(.words)
                    .textContentType(.name)

                    HStack {
                        TextField("Email", text: $email)
                            .disabled(!canEditEmail)
                        Button(action: {
                            showEditEmailAlert = true
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.gray)
                        }
                        .alert("Edit Email", isPresented: $showEditEmailAlert) {
                            Button("Cancel", role: .cancel) {}
                            Button("Continue") {
                                canEditEmail = true
                            }
                        } message: {
                            Text("You are going to modify your email address.")
                        }
                    }
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                }

                Section(header: Text("Current Password"), footer: Text("Required to confirm any changes.")) {
                    SecureField("Current Password", text: $currentPassword)

                    Button("Forgot Password?") {
                        if let email = Auth.auth().currentUser?.email {
                            Auth.auth().sendPasswordReset(withEmail: email) { error in
                                if let error = error {
                                    self.errorMessage = error.localizedDescription
                                } else {
                                    self.errorMessage = "Password reset email sent to \(email)"
                                }
                            }
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }

                Section(header: Text("New Password")) {
                    SecureField("New Password", text: $newPassword)
                    SecureField("Confirm New Password", text: $confirmPassword)
                }

                Section {
                    Button(action: saveChanges) {
                        if isSaving {
                            ProgressView()
                        } else {
                            Text("Save Changes")
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(fullName.isEmpty || email.isEmpty || currentPassword.isEmpty)
                }
            }
            .navigationTitle("My Account")
            .navigationBarTitleDisplayMode(.large)
            .alert("Saved", isPresented: $showSavedAlert) {
                Button("OK", role: .cancel) {}
            }
            .alert(item: $errorMessage) { message in
                Alert(title: Text("Alert"), message: Text(message), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                fullName = authVM.currentUser?.fullName ?? ""
                email = authVM.currentUser?.email ?? ""
            }
        }
    }

    private func saveChanges() {
        guard let user = Auth.auth().currentUser,
              let uid = authVM.currentUser?.uid else { return }

        isSaving = true
        errorMessage = nil

        // Reauthenticate user before making changes
        let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: currentPassword)

        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                self.errorMessage = "Authentication failed: \(error.localizedDescription)"
                self.isSaving = false
                return
            }

            // Update email if changed
            if self.email != user.email {
                user.sendEmailVerification(beforeUpdatingEmail: self.email) { error in
                    if let error = error {
                        self.errorMessage = "Email update failed: \(error.localizedDescription)"
                    }
                }
            }

            // Update password if filled
            if !self.newPassword.isEmpty {
                if self.newPassword != self.confirmPassword {
                    self.errorMessage = "Passwords do not match"
                    self.isSaving = false
                    return
                }
                user.updatePassword(to: self.newPassword) { error in
                    if let error = error {
                        self.errorMessage = "Password update failed: \(error.localizedDescription)"
                    }
                }
            }

            // Update full name in Firestore
            authVM.firestore.collection("users").document(uid).updateData([
                "fullName": self.fullName
            ]) { error in
                self.isSaving = false
                if error == nil {
                    authVM.currentUser?.fullName = self.fullName
                    self.showSavedAlert = true
                } else {
                    self.errorMessage = "Failed to update name: \(error?.localizedDescription ?? "Unknown error")"
                }
            }
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}
