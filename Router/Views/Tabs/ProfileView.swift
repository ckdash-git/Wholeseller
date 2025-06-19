import SwiftUI
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
    @State private var isBiometricEnabled = false
    @State private var authStatus: String?
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .system

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Profile")
                    .font(.title)
                    .bold()
                    .padding(.top, 4)

                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding(.top, 10)

                Text("Md Kamrul Hasan")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("kamrulbd.cityedu@gmail.com")
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
                        profileRow(title: "My Account", subtitle: "Changes to your account details", icon: "person", showArrow: true, showWarning: true) {
                            print("My Account tapped")
                        }
                        profileRow(title: "Saved Contact", subtitle: "Manage your saved contact", icon: "tray", showArrow: true) {
                            print("Saved Contact tapped")
                        }
                        biometricRow
                        profileRow(title: "Two-Factor Authentication", subtitle: "Further secure your account for safety", icon: "shield", showArrow: true) {
                            print("Two-Factor Authentication tapped")
                        }
                        profileRow(title: "Log out", subtitle: "Further secure your account for safety", icon: "arrowshape.turn.up.left", showArrow: true) {
                            print("Log out tapped")
                        }
                    }
                }
                .listStyle(.insetGrouped)
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
        Button(action: action) {
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
                if showArrow {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Enable Face ID / Touch ID") { success, authError in
                DispatchQueue.main.async {
                    if !success {
                        isBiometricEnabled = false
                        authStatus = "Authentication failed"
                    }
                }
            }
        } else {
            isBiometricEnabled = false
            authStatus = "Biometric authentication not available"
        }
    }
}
