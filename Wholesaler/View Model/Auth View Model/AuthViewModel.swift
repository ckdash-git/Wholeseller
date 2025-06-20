import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var userEmail: String = ""
    @Published var userPassword: String = ""
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isError: Bool = false
    @Published var isLoading: Bool = true
    @Published var navigateToOTPVerification = false
    private let auth = Auth.auth()
    let firestore = Firestore.firestore()
    
    init() {
        Task {
            await loadCurrentUser()
        }
    }
    
    func loadCurrentUser() async {
        let current = auth.currentUser
        if let user = current {
            self.userSession = user
            _ = await fetchUser(by: user.uid)
        } else {
        }
        isLoading = false
    }
    
    func login(email: String, password: String) async -> Result<FirebaseAuth.User, Error> {
        do {
            let authResult = try await auth.signIn(withEmail: email, password: password)
            let userUID = authResult.user.uid
            
            let documentRef = firestore.collection("users").document(userUID)
            let document = try await documentRef.getDocument()
            
            if !document.exists {
                // Create user entry if it doesn't exist
                let fullName = authResult.user.displayName ?? ""
                await createUser(uid: userUID, email: email, fullName: fullName)
            }

            let fetchedUser = await fetchUser(by: userUID)
            self.currentUser = fetchedUser
            return .success(authResult.user)
        } catch {
            return .failure(error)
        }
    }
    
    
    func createUser(uid: String, email: String, fullName: String) async {
        let user = User(uid: uid, email: email, fullName: fullName)
        do {
            try firestore.collection("users").document(uid).setData(from: user)
            self.currentUser = user  // Update currentUser with the new user data
        } catch {
            isError = true
        }
    }
    
    func fetchUser(by uid: String) async -> User {
        do {
            let document = try await firestore.collection("users").document(uid).getDocument()
            let fetchedUser = try document.data(as: User.self)
            self.currentUser = fetchedUser
            return fetchedUser ?? User(uid: uid, email: "", fullName: "")
        } catch {
            isError = true
            return User(uid: uid, email: "", fullName: "")
        }
    }
    
    func signOut() {
        do {
            userSession = nil
            currentUser = nil
            try auth.signOut()
        }catch {
            isError = true
        }
    }
    
    func deleteAccount(email: String, password: String) async {
        do {
            let success = await reauthenticateUser(email: email, password: password)
            if !success {
                return
            }
            
            let uid = Auth.auth().currentUser?.uid ?? ""
            
            // First, delete any Firestore data related to the user
            try await Firestore.firestore().collection("user_settings").document(uid).delete()
            try await Firestore.firestore().collection("user_data").document(uid).delete()
            try await Firestore.firestore().collection("users").document(uid).delete()
            
            // Now delete the user from Firebase Authentication
            try await Auth.auth().currentUser?.delete()
            
            // Clear session
            userSession = nil
            currentUser = nil
        } catch {
        }
    }
    
    func reauthenticateUser(email: String, password: String) async -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        do {
            try await user.reauthenticate(with: credential)
            return true
        } catch {
            return false
        }
    }
    
    func resetPassword(by email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    func getUIDForEmail(email: String) async -> String? {
        do {
            let querySnapshot = try await firestore.collection("users")
                .whereField("email", isEqualTo: email)
                .getDocuments()
            
            if let document = querySnapshot.documents.first {
                return document.documentID
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func checkIfEmailExists(email: String) async -> Bool {
        do {
            let querySnapshot = try await firestore.collection("users")
                .whereField("email", isEqualTo: email)
                .getDocuments()
            
            return !querySnapshot.documents.isEmpty
        } catch {
            return false
        }
    }
}
