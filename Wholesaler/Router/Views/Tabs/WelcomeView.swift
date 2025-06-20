//
//  HomeView.swift
//  Wholeseller
//
//  Created by CHANDAN on 18/06/25.
//

//
//  HomeView.swift
//  Wholeseller
//
//  Created by CHANDAN on 18/06/25.
//

import SwiftUI

struct WelcomeView: View {
    @State private var searchText = ""
    @State private var showLocationSheet = false
    @StateObject private var locationManager = LocationManager()
    @State private var showPermissionAlert = false
    enum CategoryDestination {
        case food, icecreams, grocery, snacks, fruits
    }
    @State private var selectedCategory: CategoryDestination?
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 0) {
                    headerView
                    ScrollView {
                        NavigationLink(
                            destination: destinationView(),
                            isActive: Binding(
                                get: { selectedCategory != nil },
                                set: { if !$0 { selectedCategory = nil } }
                            )
                        ) {
                            EmptyView()
                        }
                        VStack(spacing: 0) {
                            promotionalBanner
                            categoriesSection
                            picksForYouSection
                            Spacer(minLength: 100)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .background(Color(.systemBackground))
            }

            if showPermissionAlert {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()

                    VStack(spacing: 16) {
                        Text("For a better experience, your device will need to use Location Accuracy")
                            .font(.headline)
                            .multilineTextAlignment(.center)

                        Text("The following settings should be on:")
                            .font(.subheadline)

                        Label("Device location", systemImage: "location.fill")
                            .font(.subheadline)

                        Text("Location Accuracy helps apps find your location more precisely by using Wi-Fi, Bluetooth, and mobile networks.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        VStack(spacing: 20) {
                            Button(action: {
                                showPermissionAlert = false
                            }) {
                                Text("No, thanks")
                                    .padding()
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }

                            Button(action: {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                Text("Turn On")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(Color.orange)
                                    .cornerRadius(8)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .padding(30)
                }
            }
        }
        .onChange(of: locationManager.locationPermissionGranted) { granted in
            if granted { showLocationSheet = true }
        }
        .onChange(of: locationManager.locationPermissionDenied) { denied in
            if denied { showPermissionAlert = true }
        }
        .ignoresSafeArea()
    }
    
    private var headerView: some View {
        VStack(spacing: 15) {
            Spacer().frame(height: 10)
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.black)
                            .font(.caption)
                        Text("Location")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Button(action: {
                        showLocationSheet = true
                    }) {
                        HStack {
                            Text("Al Safa Street, Al Wasi")
                                .font(.headline)
                                .fontWeight(.medium)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .fullScreenCover(isPresented: $showLocationSheet) {
                                   LocationView()
                               }
                }

                Spacer()

                ZStack {
                    Button(action: {}) {
                        Image(systemName: "cart.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }

                    // Badge
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Text("2")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                        .offset(x: 12, y: -12)
                }
            }

            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.orange, lineWidth: 1)
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(edges: .top)
        .background(
            Color.orange.opacity(0.1)
                .clipShape(
                    RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight])
                )
        )
        .padding(.horizontal, 0)
        // Removed .padding(.top, 10)
    }
    
    private var searchFilterView: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.orange, lineWidth: 2)
            )
            
            Button(action: {}) {
                HStack {
                    Text("Filter")
                        .fontWeight(.medium)
                    
                    Image(systemName: "slider.horizontal.3")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(25)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 15)
    }
    
    private var promotionalBanner: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Gonna Be a Good Day!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Free delivery, lower fees, &")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("10% cashback, pickup!")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Button(action: {}) {
                        Text("Order Now")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .cornerRadius(25)
                    }
                    .padding(.top, 8)
                }
                
                Spacer()
                
                // Sushi image placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 120, height: 90)
                    .overlay(
                        Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.7))
                    )
            }
            .padding(20)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange, Color.red.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Categories")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                NavigationLink(destination: GroceryView()) {
                    Text("See All")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    categoryItem(icon: "fork.knife", title: "Food", color: .green)
                    categoryItem(icon: "cart", title: "Grocery", color: .orange)
                    categoryItem(icon: "", title: "Ice creams", color: .green)
                    categoryItem(icon: "", title: "Snacks", color: .gray)
                    categoryItem(icon: "", title: "Fruits", color: .orange)
                    Spacer()
                }
                .padding(.horizontal)
            }

            .padding(.horizontal, 20)
        }
        .padding(.top, 25)
    }
    
    private func categoryItem(icon: String, title: String, color: Color) -> some View {
        Button(action: {
            switch title {
            case "Food":
                selectedCategory = .food
            case "Grocery":
                selectedCategory = .grocery
            case "Ice creams":
                selectedCategory = .icecreams
            case "Snacks":
                selectedCategory = .snacks
            case "Fruits":
                selectedCategory = .fruits
            default:
                break
            }
        }) {
            VStack(spacing: 8) {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundColor(color)
                    )
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }

    @ViewBuilder
    private func destinationView() -> some View {
        switch selectedCategory {
        case .food:
            FoodView()
        case .grocery:
            GroceryView()
        case .icecreams:
            IceCreamView()
        case .snacks:
            SnacksView()
        case .fruits:
            FruitsView()
        case .none:
            EmptyView()
        }
    }
    
    private var picksForYouSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Picks For You")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("🔥")
                    .font(.title2)
                
                Spacer()
                
                Button("See All") {}
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    restaurantCard(
                        name: "Taco Bell",
                        rating: "4.7",
                        reviews: "(2.3k)",
                        time: "25 min",
                        difficulty: "Easy",
                        provider: "By Walmart"
                    )
                    
                    restaurantCard(
                        name: "Pizza Hut",
                        rating: "4.5",
                        reviews: "(1.8k)",
                        time: "30 min",
                        difficulty: "Easy",
                        provider: "By Delivery"
                    )
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 25)
    }
    
    private func restaurantCard(name: String, rating: String, reviews: String, time: String, difficulty: String, provider: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.3))
                .frame(width: 280, height: 160)
                .overlay(
                    VStack {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                    }
                )
                .overlay(
                    VStack {
                        HStack {
                            HStack(spacing: 4) {
                                Text(rating)
                                    .fontWeight(.semibold)
                                Text(reviews)
                                    .foregroundColor(.secondary)
                            }
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white)
                            .cornerRadius(12)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 16))
                                    .padding(8)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.top, 12)
                        
                        Spacer()
                    }
                )
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.orange)
                            .clipShape(Circle())
                    }
                }
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text(time)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Text(difficulty)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Text(provider)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// Helper for rounded corners on specific corners
struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// View extension for corner radius on specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}







