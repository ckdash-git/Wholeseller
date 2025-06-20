//
//  SnacksView.swift
//  Wholeseller
//
//  Created by CHANDAN on 20/06/25.
//

import SwiftUI
 
struct SnacksView: View {
    @State private var searchText = ""
    @State private var cartCount = 4
 
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
                        TextField("Search snacks...", text: $searchText)
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
                        Text("Crunch Into Your Favorite Snacks")
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
                gradient: Gradient(colors: [Color.orange, Color.red.opacity(0.8)]),
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
                ProductCategoryCard(title: "Chips", systemImage: "bag.fill", backgroundColor: Color.yellow.opacity(0.2), isNew: true)
                ProductCategoryCard(title: "Popcorn", systemImage: "popcorn.fill", backgroundColor: Color.orange.opacity(0.2), isNew: false)
                ProductCategoryCard(title: "Nuts", systemImage: "leaf", backgroundColor: Color.brown.opacity(0.2), isNew: false)
                ProductCategoryCard(title: "Granola Bars", systemImage: "rectangle.on.rectangle", backgroundColor: Color.green.opacity(0.2), isNew: true)
            }
 
            HStack(spacing: 12) {
                ProductCategoryCard(title: "Pretzels", systemImage: "circle.grid.cross", backgroundColor: Color.purple.opacity(0.2), isNew: false)
                ProductCategoryCard(title: "Cookies", systemImage: "square.grid.2x2.fill", backgroundColor: Color.blue.opacity(0.2), isNew: false, cartCount: 2)
                ProductCategoryCard(title: "Crackers", systemImage: "cube.fill", backgroundColor: Color.gray.opacity(0.2), isNew: false)
                ProductCategoryCard(title: "Trail Mix", systemImage: "leaf.fill", backgroundColor: Color.teal.opacity(0.2), isNew: false)
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
                            gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.red]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120)
 
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Snack Attack Deals")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
 
                            Spacer()
 
                            Text("Buy 1 Get 1")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                                .padding(8)
                                .background(Color.white.opacity(0.9))
                                .clipShape(Circle())
                        }
 
                        Text("CRUNCH FEST")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
 
                        HStack {
                            HStack {
                                Image(systemName: "flame")
                                Text("HOT & CRISPY")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
 
                            Spacer()
 
                            Button("ORDER NOW") {
                                // Order action
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
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
                Text("Top Snack Stores")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button("Show all") {
                    // Show all action
                }
                .foregroundColor(.gray)
            }
 
            StoreCard(
                name: "Snack Shack",
                deliveryTime: "Delivering by 5:00 PM",
                distance: "1.5 mi",
                priceLevel: "$",
                hasInStorePrice: true,
                hasLowPrices: true
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 100)
    }
}
 
