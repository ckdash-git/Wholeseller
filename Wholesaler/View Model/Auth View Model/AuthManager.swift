////
////  AuthManager.swift
////  Wholeseller
////
////  Created by CHANDAN on 18/06/25.
////
//
//import Foundation
//
//class AuthManager {
//    static let shared = AuthManager()
//
//    // Handle login with completion handler
//    func login(completion: @escaping (Bool) -> Void) {
//        Auth0
//            .webAuth()
//            .start { result in
//                switch result {
//                case .success(_): // Successfully logged in
//                    completion(true)
//                case .failure(let error): // Error occurred during login
//                    completion(false)
//                }
//            }
//    }
//
//    // Handle logout with completion handler
//    func logout(completion: @escaping (Bool) -> Void) {
//        Auth0
//            .webAuth()
//            .clearSession { result in
//                switch result {
//                case .success(): // Successfully logged out
//                    completion(true)
//                case .failure(let error): // Error occurred during logout
//                    completion(false)
//                }
//            }
//    }
//}
