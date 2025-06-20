//
//  LogoutButton.swift
//  Wholeseller
//
//  Created by CHANDAN on 19/06/25.
//

import SwiftUI
import FirebaseAuth

struct LogoutButton: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(role: .destructive) {
            do {
                try Auth.auth().signOut()
                // Dismiss to root or login
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Failed to sign out: \(error.localizedDescription)")
            }
        } label: {
            HStack {
                Image(systemName: "arrow.backward.circle.fill")
                Text("Log Out")
                    .fontWeight(.medium)
            }
            .foregroundColor(.red)
        }
    }
}

#Preview {
    LogoutButton()
}
