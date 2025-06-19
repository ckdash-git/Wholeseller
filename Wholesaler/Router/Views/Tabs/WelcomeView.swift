//
//  HomeView.swift
//  Wholeseller
//
//  Created by CHANDAN on 18/06/25.
//

import SwiftUI
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var currentAddress: String = "Fetching location..."

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            if let placemark = placemarks?.first {
                self.currentAddress = [
                    placemark.subThoroughfare,
                    placemark.thoroughfare,
                    placemark.locality
                ]
                .compactMap { $0 }
                .joined(separator: ", ")
            }
        }
    }
}

struct AllCategoriesView: View {
    var body: some View {
        List {
            Text("Food")
            Text("Stores")
            Text("Grocery")
            Text("Ice Creams")
            Text("Snacks")
            Text("Fruits")
            // Add more categories as needed
        }
        .navigationTitle("All Categories")
        .background(Color(uiColor: .systemBackground))
    }
}

struct WelcomeView: View {
    @State private var searchText = ""
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(uiColor: .systemBackground)
                    .edgesIgnoringSafeArea(.all)

                GeometryReader { geometry in
                    ScrollView {
                        VStack(spacing: 0) {
                            Spacer().frame(height: 120) // Space for fixed header and search

                            promotionalBanner
                            categoriesSection
                            picksForYouSection
                            Spacer(minLength: 100)
                        }
                        .background(Color(uiColor: .systemBackground))
                    }
                }

                VStack(spacing: 10) {
                    headerView
                    searchFilterView
                }
                .background(Color(uiColor: .systemBackground))
                .padding(.top, 10)
                .padding(.horizontal, 20)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            }
            .navigationBarHidden(true)
            .background(Color(uiColor: .systemBackground))
        }
        .background(Color(uiColor: .systemBackground))
    }

    private var headerView: some View {
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

                HStack {
                    Text(locationManager.currentAddress)
                        .font(.headline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            ZStack {
                Button(action: {}) {
                    Image(systemName: "bag.fill")
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
            .background(Color(uiColor: .systemGray6))
            .cornerRadius(25)

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

                NavigationLink(destination: AllCategoriesView()) {
                    Text("See All")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    categoryItem(icon: "fork.knife", title: "Food", color: .green)
                    categoryItem(icon: "building.2", title: "Stores", color: .gray)
                    categoryItem(icon: "cart", title: "Grocery", color: .orange)
                    categoryItem(icon: "", title: "Ice creams", color: .green)
                    categoryItem(icon: "", title: "Snacks", color: .gray)
                    categoryItem(icon: "", title: "Fruits", color: .orange)
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
