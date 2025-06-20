import Foundation
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore
import Firebase
import CryptoKit

class AppleSignInHandler: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    var onSignInSuccess: ((FirebaseAuth.User) -> Void)?
    var onSignInFailure: ((Error) -> Void)?
    // Add state for nonce
    private var currentNonce: String?
    
    // Add function to generate random nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    // Add SHA256 hash function
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // ASAuthorizationControllerDelegate methods
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                let error = NSError(domain: "Apple SignIn",
                                   code: -1,
                                   userInfo: [NSLocalizedDescriptionKey: "Invalid state: A login callback was received, but no login request was sent."])
                onSignInFailure?(error)
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                let error = NSError(domain: "Apple SignIn",
                                   code: -1,
                                   userInfo: [NSLocalizedDescriptionKey: "Unable to fetch identity token"])
                onSignInFailure?(error)
                return
            }
            
            // Create Apple credential for Firebase
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                     idToken: idTokenString,
                                                     rawNonce: nonce)
            
            // Sign in with Firebase
            Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                guard let self = self else { return }
                
                if let error = error {
                    self.onSignInFailure?(error)
                    return
                }
                
                guard let user = authResult?.user else {
                    self.onSignInFailure?(NSError(domain: "Apple SignIn",
                                                 code: -2,
                                                 userInfo: [NSLocalizedDescriptionKey: "Failed to get user from auth result"]))
                    return
                }
                
                // For first time sign-in, we need to update the user's profile
                let fullName = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")
                
                // Store Apple user info in UserDefaults for later use
                if let email = appleIDCredential.email, !email.isEmpty {
                    UserDefaults.standard.set(email, forKey: "appleUserEmail")
                }
                
                if !fullName.isEmpty {
                    UserDefaults.standard.set(fullName, forKey: "appleUserName")
                    
                    // Only update profile if we have a name to set
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = fullName
                    changeRequest?.commitChanges { [weak self] error in
                        if let error = error {
                           
                        }
                        
                        // Store user info in Firestore
                        self?.updateFirestoreUserRecord(for: user, fullName: fullName, email: appleIDCredential.email)
                    }
                } else {
                    // If no name is available, still try to update Firestore
                    // Maybe they signed in before and we have their details
                    let savedName = UserDefaults.standard.string(forKey: "appleUserName") ?? ""
                    self.updateFirestoreUserRecord(for: user, fullName: savedName, email: appleIDCredential.email)
                }
                
                // Call success handler
                self.onSignInSuccess?(user)
            }
        }
    }
    
    private func updateFirestoreUserRecord(for user: FirebaseAuth.User, fullName: String, email: String?) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        // Check if user exists first
        userRef.getDocument { document, error in
            if let error = error {
                return
            }
            
            var userData: [String: Any] = [
                "uid": user.uid,
                "email": email ?? user.email ?? "",
                "fullName": fullName.isEmpty ? (user.displayName ?? "No Name") : fullName,
                "lastLogin": FieldValue.serverTimestamp()
            ]
            
            if let document = document, document.exists {
                // Update existing user
                userRef.updateData(userData) { error in
                    if let error = error {
                    }
                }
            } else {
                // Create new user
                userData["createdAt"] = FieldValue.serverTimestamp()
                userRef.setData(userData) { error in
                    if let error = error {
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.onSignInFailure?(error)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Modern way to get key window that works with UIScene
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }) else {
            // Fallback for older iOS versions
            return UIApplication.shared.windows.first { $0.isKeyWindow }!
        }
        return window
    }
}
