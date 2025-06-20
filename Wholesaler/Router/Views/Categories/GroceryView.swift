//
//  GrocerysView.swift
//  Wholeseller
//
//  Created by CHANDAN on 20/06/25.
//

import SwiftUI
 
struct GroceryView: View {
    @State private var searchText = ""
    @State private var cartCount = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header Section (now outside ScrollView)
                headerSection
                ScrollView {
                    VStack(spacing: 0) {
                        // Product Categories
                        productCategoriesSection
                        
                        // Promotional Banner
                        promotionalBanner
                        
                        // Stores Section
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
            // Status bar and search area
            VStack(spacing: 14) {
                // Search Bar and Cart
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search...", text: $searchText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(25)
                    
                    Spacer().frame(width: 12)
                    
                  
                    
                    // Cart Button
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
                
                // Title
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Find Your Daily Grocery")
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
                gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
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
            // First Row
            HStack(spacing: 12) {
                ProductCategoryCard(
                    title: "Beef Bone",
                    systemImage: "fork.knife",
                    backgroundColor: Color.pink.opacity(0.3),
                    isNew: false
                )
                
                ProductCategoryCard(
                    title: "Pulses",
                    systemImage: "circle.grid.3x3",
                    backgroundColor: Color.yellow.opacity(0.3),
                    isNew: true
                )
                
                ProductCategoryCard(
                    title: "Bell Pepper",
                    systemImage: "leaf",
                    backgroundColor: Color.pink.opacity(0.3),
                    isNew: false
                )
                
                ProductCategoryCard(
                    title: "Ginger",
                    systemImage: "leaf.fill",
                    backgroundColor: Color.green.opacity(0.3),
                    isNew: false
                )
            }
            
            // Second Row
            HStack(spacing: 12) {
                ProductCategoryCard(
                    title: "Egg White",
                    systemImage: "circle",
                    backgroundColor: Color.gray.opacity(0.2),
                    isNew: false
                )
                
                ProductCategoryCard(
                    title: "Red Apple",
                    systemImage: "apple.logo",
                    backgroundColor: Color.pink.opacity(0.3),
                    isNew: false
                )
                
                ProductCategoryCard(
                    title: "Bananas",
                    systemImage: "moon.fill",
                    backgroundColor: Color.yellow.opacity(0.3),
                    isNew: false,
                    cartCount: 3
                )
                
                ProductCategoryCard(
                    title: "Eggless",
                    systemImage: "drop",
                    backgroundColor: Color.blue.opacity(0.3),
                    isNew: false
                )
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
                            gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Healthy & Fresh")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            // Discount Badge
                            Text("DISCOUNT\n20%")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .multilineTextAlignment(.center)
                                .padding(8)
                                .background(Color.white.opacity(0.9))
                                .clipShape(Circle())
                        }
                        
                        Text("VEGETABLE")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack {
                            HStack {
                                Image(systemName: "truck")
                                Text("CALL FOR DELIVERY")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button("ORDER NOW") {
                                // Order action
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
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
                Text("Stores to help you save")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button("Show all") {
                    // Show all action
                }
                .foregroundColor(.gray)
            }
            
            StoreCard(
                name: "Pick perk markets",
                deliveryTime: "Delivery by 10:00am",
                distance: "35.8 mi",
                priceLevel: "$",
                hasInStorePrice: true,
                hasLowPrices: true
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 100)
    }
    
    private var vegetableImages: [String] {
        ["carrot", "leaf.fill", "apple.logo", "moon.fill", "drop.fill"]
    }
}
 
struct ProductCategoryCard: View {
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
 
struct StoreCard: View {
    let name: String
    let deliveryTime: String
    let distance: String
    let priceLevel: String
    let hasInStorePrice: Bool
    let hasLowPrices: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Store Logo
            Image(systemName: "storefront")
                .font(.title2)
                .foregroundColor(.orange)
                .frame(width: 50, height: 50)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
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
