import SwiftUI
import FirebaseAuth
import LocalAuthentication

enum AppTheme: String, CaseIterable, Identifiable {
    case light, dark, system
    var id: String { self.rawValue }

    var label: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

struct ProfileView: View {
    @AppStorage("biometricLockEnabled") private var isBiometricEnabled: Bool = false
    @State private var authStatus: String?
    @StateObject private var authVM = AuthViewModel()
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .system
    @State private var showBiometricAlert = false

    @State private var showMyAccount = false
    @State private var showSavedContacts = false
    @State private var showTwoFactor = false
    @State private var isLoggingOut = false
    @State private var showLogoutConfirmation = false

    private var userInitials: String {
        let nameComponents = (authVM.currentUser?.fullName ?? "").split(separator: " ")
        let initials = nameComponents.prefix(2).compactMap { $0.first.map { String($0) } }.joined()
        return initials.uppercased()
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Profile")
                    .font(.title)
                    .bold()
                    .padding(.top, 4)

                Text(userInitials)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 100, height: 100)
                    .background(Circle().fill(Color.gray))
                    .padding(.top, 10)

                Text(authVM.currentUser?.fullName ?? "Name")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(authVM.currentUser?.email ?? "Email")
                    .foregroundColor(.gray)

                Picker("App Theme", selection: $selectedTheme) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.label).tag(theme)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                List {
                    Section {
                        NavigationLink(destination: MyAccountView().environmentObject(authVM)) {
                            profileRow(title: "My Account", subtitle: "Changes to your account details", icon: "person", showArrow: true, showWarning: true)
                        }
                        NavigationLink(destination: SavedContactsView().environmentObject(authVM)) {
                            profileRow(title: "Saved Contact", subtitle: "Manage your saved contact", icon: "tray", showArrow: true)
                        }
                        biometricRow
                        NavigationLink(destination: AppVersion()) {
                            profileRow(title: "App Version", subtitle: "Version 1.0.0", icon: "shield", showArrow: true)
                        }
                        Button(action: {
                            showLogoutConfirmation = true
                        }) {
                            profileRow(title: "Log out", subtitle: "Sign out of your account", icon: "arrowshape.turn.up.left", showArrow: true)
                        }
                        .foregroundColor(.red)
                    }
                }
                .listStyle(.insetGrouped)
                .alert("Log Out", isPresented: $showLogoutConfirmation) {
                    Button("Cancel", role: .cancel) {}
                    Button("Log Out", role: .destructive) {
                        do {
                            try Auth.auth().signOut()
                            authVM.currentUser = nil
                            isLoggingOut = true
                        } catch {
                            print("Sign out failed: \(error.localizedDescription)")
                        }
                    }
                } message: {
                    Text("Are you sure you want to log out?")
                }
            }
            .fullScreenCover(isPresented: $isLoggingOut) {
                LoginView()
            }
            .alert("Biometric Authentication Failed", isPresented: $showBiometricAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(authStatus ?? "Biometric authentication failed or is unavailable.")
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(selectedTheme.colorScheme)
    }

    private var biometricRow: some View {
        HStack {
            Image(systemName: "lock")
                .foregroundColor(.green)
            VStack(alignment: .leading) {
                Text("Face ID / Touch ID")
                Text("Manage your device security")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Toggle("", isOn: $isBiometricEnabled)
                .onChange(of: isBiometricEnabled) { value in
                    if value {
                        authenticate()
                    }
                }
        }
    }

    private func profileRow(title: String, subtitle: String, icon: String, showArrow: Bool, showWarning: Bool = false, action: @escaping () -> Void = {}) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
            VStack(alignment: .leading) {
                Text(title)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            if showWarning {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
            }
        }
    }

    private func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Enable Face ID / Touch ID") { success, authError in
                DispatchQueue.main.async {
                    if !success {
                        isBiometricEnabled = false
                        showBiometricAlert = true
                    }
                }
            }
        } else {
            isBiometricEnabled = false
            showBiometricAlert = true
        }
    }
}
