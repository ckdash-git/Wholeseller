import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab: Int = 0
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        TabView(selection: $selectedTab) {
            
            WelcomeView()
                .tabItem {
                    tabItem(icon: "house.fill", label: "Home", tag: 0, selectedTab: selectedTab, color: .orange)
                }
                .tag(0)
            
            OrderHistoryView()
                .tabItem {
                    tabItem(icon: "list.bullet.rectangle.portrait.fill", label: "Orders", tag: 1, selectedTab: selectedTab, color: .orange)
                }
                .tag(1)

            PaymentView()
                .tabItem {
                    tabItem(icon: "creditcard.fill", label: "Payments", tag: 2, selectedTab: selectedTab, color: .orange)
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    tabItem(icon: "person.fill", label: "Profile", tag: 3, selectedTab: selectedTab, color: .orange)
                }
                .tag(3)
        }
        .accentColor(colorScheme == .dark ? .orange : .black)
    }

    private func tabItem(icon: String, label: String, tag: Int, selectedTab: Int, color: Color) -> some View {
        VStack {
            Image(systemName: icon)
                .scaleEffect(selectedTab == tag ? 1.4 : 1.0)
                .shadow(color: selectedTab == tag ? color.opacity(0.9) : .clear, radius: 12, x: 0, y: 0)
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
            Text(label)
        }
    }
}

#Preview {
    HomeView()
}
