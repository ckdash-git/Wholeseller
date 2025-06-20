//
//  FoodView.swift
//  Wholeseller
//
//  Created by CHANDAN on 20/06/25.
//

import SwiftUI

struct FoodView: View {
    @State private var searchText = ""
    @State private var cartCount = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerSection
                ScrollView {
                    VStack(spacing: 0) {
                        foodCategoriesSection
                        promotionalBanner
                        restaurantsSection
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
                        TextField("Search for dishes, restaurants...", text: $searchText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(25)

                    Spacer().frame(width: 12)

                    Button(action: {}) {
                        ZStack {
                            Image(systemName: "bag")
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
                        Text("What do you want to eat today?")
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
                gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(
                RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight])
            )
        )
    }

    private var foodCategoriesSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                FoodCategoryCard(title: "Pizza", systemImage: "flame", backgroundColor: Color.red.opacity(0.3), isNew: true)
                FoodCategoryCard(title: "Burger", systemImage: "takeoutbag.and.cup.and.straw", backgroundColor: Color.yellow.opacity(0.3))
                FoodCategoryCard(title: "Sushi", systemImage: "leaf", backgroundColor: Color.green.opacity(0.3))
                FoodCategoryCard(title: "Dessert", systemImage: "cup.and.saucer", backgroundColor: Color.pink.opacity(0.3))
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
                            gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.orange]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120)

                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Delicious Deals")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)

                            Spacer()

                            Text("SAVE\n30%")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                                .multilineTextAlignment(.center)
                                .padding(8)
                                .background(Color.white.opacity(0.9))
                                .clipShape(Circle())
                        }

                        Text("FOOD DELIVERY")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        HStack {
                            HStack {
                                Image(systemName: "bicycle")
                                Text("Fast & Fresh")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)

                            Spacer()

                            Button("ORDER NOW") {
                                // Order action
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
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

    private var restaurantsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Popular Restaurants")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button("Show all") {
                    // Show all restaurants
                }
                .foregroundColor(.gray)
            }

            StoreCard(
                name: "Burger Palace",
                deliveryTime: "Delivery in 30 mins",
                distance: "2.3 mi",
                priceLevel: "$$",
                hasInStorePrice: false,
                hasLowPrices: true
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 100)
    }
}

// Category card for food
struct FoodCategoryCard: View {
    let title: String
    let systemImage: String
    let backgroundColor: Color
    var isNew: Bool = false

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

 
