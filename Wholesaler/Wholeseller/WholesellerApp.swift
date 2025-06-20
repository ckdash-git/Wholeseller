//
//  WholesalerApp.swift
//  Wholesaler
//
//  Created by CHANDAN on 17/06/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import AuthenticationServices
import LocalAuthentication

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct WholesellerApp: App {
    @AppStorage("biometricLockEnabled") private var biometricLockEnabled: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authVM = AuthViewModel()
    
    @State private var isAppLocked = false
    @State private var backgroundDate: Date?
    @Environment(\.scenePhase) private var scenePhase
    @State private var isScreenCaptured = UIScreen.main.isCaptured
    
    var isReadyToShowMainApp: Bool {
        !authVM.isLoading && authVM.userSession != nil
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if Auth.auth().currentUser != nil {
                    HomeView()
                        .environmentObject(authVM)
                } else {
                    LoginView()
                        .environmentObject(authVM)
                }
                
                if isAppLocked && biometricLockEnabled {
                    AppLockView(onUnlock: authenticate)
                }
                
                if isScreenCaptured {
                    Color.black.opacity(0.9).ignoresSafeArea()
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.yellow)
                        Text("Screen Mirroring Detected")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text("Please stop screen mirroring to continue using the app.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                    isScreenCaptured = UIScreen.main.isCaptured
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background {
                    backgroundDate = Date()
                }
                
                if newPhase == .active {
                    // Ensure the app really went to background first
                    guard let backgroundTime = backgroundDate else { return }
                    let elapsed = Date().timeIntervalSince(backgroundTime)
                    if elapsed > 120 && Auth.auth().currentUser != nil {
                        isAppLocked = true
                    }
                    backgroundDate = nil
                }
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock the app"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    self.isAppLocked = !success
                }
            }
        }
    }
}
