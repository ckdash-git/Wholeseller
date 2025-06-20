//
//  LocationView.swift
//  Wholeseller
//
//  Created by CHANDAN on 20/06/25.
//

import SwiftUI

struct LocationView: View {
    @State private var searchText = ""
    @State private var savedLocations: [SavedLocation] = []
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 0) {
                    
                    // Top Cancel Button
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Title and Search Bar
                    VStack(spacing: 20) {
                        Text("Your Location")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                            
                            TextField("Search a new address", text: $searchText)
                                .font(.system(size: 16))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange, lineWidth: 1)
                                .background(Color.gray.opacity(0.1).cornerRadius(12))
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                    
                    // Enable Location
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 20))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Current location")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.orange)
                                
                                Text("Enable your current location for better services")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button("Enable") {
                                if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION"),
                                   UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.orange)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.orange, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    
                    // Saved Locations Section
                    if !savedLocations.isEmpty {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("Saved Location")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                            
                            ForEach(savedLocations) { location in
                                LocationRow(
                                    icon: location.icon,
                                    title: location.title,
                                    address: location.address
                                )
                                
                                Divider()
                                    .padding(.horizontal, 20)
                            }
                        }
                    }

                    Spacer()
                    
                    
                  
                }
                .background(Color.white)
                .navigationBarHidden(true)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Saved Location Model
struct SavedLocation: Identifiable {
    let id: UUID
    let icon: String
    let title: String
    let address: String
}

// MARK: - Location Row View
struct LocationRow: View {
    let icon: String
    let title: String
    let address: String
    var onSelect: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .font(.system(size: 20))
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Text(address)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect?()
        }
    }
}

 
