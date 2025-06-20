//
//  FruitsView.swift
//  Wholeseller
//
//  Created by CHANDAN on 20/06/25.
//

import SwiftUI

struct FruitsView: View {
    @State private var searchText = ""
    @State private var cartCount = 3

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
                        TextField("Search fruits...", text: $searchText)
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
                        Text("Fresh Fruits Delivered Fast")
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
                gradient: Gradient(colors: [Color.green, Color.teal.opacity(0.8)]),
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
                ProductCategoryCard(title: "Apples", systemImage: "applelogo", backgroundColor: Color.red.opacity(0.2), isNew: true)
                ProductCategoryCard(title: "Bananas", systemImage: "leaf.fill", backgroundColor: Color.yellow.opacity(0.2), isNew: false)
                ProductCategoryCard(title: "Oranges", systemImage: "sun.max.fill", backgroundColor: Color.orange.opacity(0.2), isNew: false)
                ProductCategoryCard(title: "Berries", systemImage: "circle.fill", backgroundColor: Color.purple.opacity(0.2), isNew: true)
            }

            HStack(spacing: 12) {
                ProductCategoryCard(title: "Grapes", systemImage: "drop.fill", backgroundColor: Color.indigo.opacity(0.2), isNew: false)
                ProductCategoryCard(title: "Melons", systemImage: "moon.fill", backgroundColor: Color.green.opacity(0.2), isNew: false, cartCount: 1)
                ProductCategoryCard(title: "Pineapple", systemImage: "star.fill", backgroundColor: Color.orange.opacity(0.2), isNew: false)
                ProductCategoryCard(title: "Mixed Fruit", systemImage: "tray.fill", backgroundColor: Color.cyan.opacity(0.2), isNew: false)
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
                            gradient: Gradient(colors: [Color.green.opacity(0.8), Color.teal]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120)

                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Fruit Fiesta")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)

                            Spacer()

                            Text("20% OFF")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .padding(8)
                                .background(Color.white.opacity(0.9))
                                .clipShape(Circle())
                        }

                        Text("NATURAL TASTE")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        HStack {
                            HStack {
                                Image(systemName: "leaf")
                                Text("ORGANIC PICKS")
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
                Text("Top Fruit Markets")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button("Show all") {
                    // Show all action
                }
                .foregroundColor(.gray)
            }

            StoreCard(
                name: "Fruit Basket",
                deliveryTime: "Delivering by 4:30 PM",
                distance: "2.0 mi",
                priceLevel: "$$",
                hasInStorePrice: true,
                hasLowPrices: false
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 100)
    }
}

 
