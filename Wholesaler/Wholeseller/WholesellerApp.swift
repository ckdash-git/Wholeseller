//
//  WholesalerApp.swift
//  Wholesaler
//
//  Created by CHANDAN on 17/06/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct WholesellerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authVM = AuthViewModel()
    var body: some Scene {
        WindowGroup {
//            LoginView()
            HomeView()
                .environmentObject(authVM)
        }
    }
}
