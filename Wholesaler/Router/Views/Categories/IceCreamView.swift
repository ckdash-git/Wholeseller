//
//  IceCreamView.swift
//  Wholeseller
//
//  Created by CHANDAN on 20/06/25.
//


import SwiftUI
 
struct IceCreamView: View {
    @State private var searchText = ""
    @State private var cartCount = 2
 
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerSection
                ScrollView {
                    VStack(spacing: 0) {
                        productCategoriesSection
                        promotionalBanner
                        storesSection
                    }
                }
            }
            .background(Color(.systemBackground))
            .ignoresSafeArea(edges: .top)
        }
//        .navigationBarHidden(true)
    }
 
    private var headerSection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 14) {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search ice cream...", text: $searchText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(25)
 
                    Spacer().frame(width: 12)
 
                    Button(action: {}) {
                        ZStack {
                            Image(systemName: "cart")
                                .foregroundColor(.black)
                                .font(.title2)
 
                            if cartCount > 0 {
                                Text("\(cartCount)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                        .padding(12)
                        .background(Color.white)
                        .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
 
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Find Your Favorite Ice Cream")
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 40)
        .padding(.bottom, 20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.pink, Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(
                RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight])
            )
        )
    }
 
    private var productCategoriesSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                IceCreamProductCategoryCard(title: "Vanilla Cone", systemImage: "snowflake", backgroundColor: Color.pink.opacity(0.2), isNew: true)
                IceCreamProductCategoryCard(title: "Chocolate Scoop", systemImage: "circle.fill", backgroundColor: Color.brown.opacity(0.2), isNew: false)
                IceCreamProductCategoryCard(title: "Mint Chip", systemImage: "leaf.fill", backgroundColor: Color.green.opacity(0.2), isNew: false)
                IceCreamProductCategoryCard(title: "Strawberry Bar", systemImage: "cube.fill", backgroundColor: Color.red.opacity(0.2), isNew: false)
            }
 
            HStack(spacing: 12) {
                IceCreamProductCategoryCard(title: "Mango Sorbet", systemImage: "drop.fill", backgroundColor: Color.orange.opacity(0.2), isNew: false)
                IceCreamProductCategoryCard(title: "Cookies & Cream", systemImage: "rectangle.grid.1x2", backgroundColor: Color.gray.opacity(0.2), isNew: true)
                IceCreamProductCategoryCard(title: "Popsicles", systemImage: "sun.max.fill", backgroundColor: Color.yellow.opacity(0.2), isNew: false, cartCount: 3)
                IceCreamProductCategoryCard(title: "Blueberry Swirl", systemImage: "moon.stars.fill", backgroundColor: Color.blue.opacity(0.2), isNew: false)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
 
    private var promotionalBanner: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.pink]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120)
 
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Chill with a Deal")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
 
                            Spacer()
 
                            Text("20% OFF")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                                .padding(8)
                                .background(Color.white.opacity(0.9))
                                .clipShape(Circle())
                        }
 
                        Text("ICE CREAM FEST")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
 
                        HStack {
                            HStack {
                                Image(systemName: "snowflake")
                                Text("DELIVERING HAPPINESS")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
 
                            Spacer()
 
                            Button("ORDER NOW") {
                                // Order action
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white)
                            .cornerRadius(15)
                        }
                    }
                    .padding()
 
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }
 
    private var storesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Popular Ice Cream Shops")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button("Show all") {
                    // Show all action
                }
                .foregroundColor(.gray)
            }
 
            StoreCard(
                name: "Scoopy's Delight",
                deliveryTime: "Delivering by 4:00 PM",
                distance: "2.1 mi",
                priceLevel: "$$",
                hasInStorePrice: true,
                hasLowPrices: true
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 100)
    }
}
 
// MARK: - Reusable Views
 
struct IceCreamProductCategoryCard: View {
    let title: String
    let systemImage: String
    let backgroundColor: Color
    let isNew: Bool
    var cartCount: Int = 0
 
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .frame(height: 70)
 
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundColor(.primary)
 
                if isNew {
                    VStack {
                        HStack {
                            Spacer()
                            Text("New")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                        Spacer()
                    }
                    .padding(6)
                }
 
                if cartCount > 0 {
                    VStack {
                        HStack {
                            Spacer()
                            Text("\(cartCount)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(6)
                }
            }
 
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}
 
struct IceCreamStoreCard: View {
    let name: String
    let deliveryTime: String
    let distance: String
    let priceLevel: String
    let hasInStorePrice: Bool
    let hasLowPrices: Bool
 
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "icecream")
                .font(.title2)
                .foregroundColor(.pink)
                .frame(width: 50, height: 50)
                .background(Color.pink.opacity(0.1))
                .cornerRadius(12)
 
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .fontWeight(.semibold)
 
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .foregroundColor(.green)
                        .font(.caption)
 
                    Text(deliveryTime)
                        .foregroundColor(.green)
                        .font(.caption)
 
                    Text("•")
                        .foregroundColor(.gray)
                        .font(.caption)
 
                    Text(distance)
                        .foregroundColor(.gray)
                        .font(.caption)
 
                    Text("•")
                        .foregroundColor(.gray)
                        .font(.caption)
 
                    Text(priceLevel)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
 
                HStack(spacing: 8) {
                    if hasInStorePrice {
                        Text("In-store price")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.yellow.opacity(0.8))
                            .cornerRadius(4)
                    }
 
                    if hasLowPrices {
                        Text("Low prices")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }
 
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
 
 
 