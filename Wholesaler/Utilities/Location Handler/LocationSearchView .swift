
import SwiftUI
import MapKit

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct LocationSearchView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var currentAddress: String

    @StateObject private var searchService = LocationSearchService()
    @State private var selectedLocation: MKMapItem?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default: San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var draggingLocation: CLLocationCoordinate2D?
    @State private var pinAddress: String = "Loading address..."

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Search for a location", text: $searchService.searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                List(searchService.searchResults, id: \.self) { result in
                    VStack(alignment: .leading) {
                        Text(result.title)
                            .fontWeight(.medium)
                        if !result.subtitle.isEmpty {
                            Text(result.subtitle)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .onTapGesture {
                        search(for: result)
                    }
                }
                .frame(maxHeight: 180)

                // Full-screen interactive map with draggable pin
                Map(coordinateRegion: $region, interactionModes: [.all], annotationItems: [IdentifiableCoordinate(coordinate: region.center)]) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                        .gesture(DragGesture()
                            .onChanged { value in
                                let newCenter = region.center
                                draggingLocation = newCenter
                            }
                            .onEnded { _ in
                                let center = region.center
                                updateAddress(for: center)
                            }
                        )
                    }
                }
                .frame(height: 300)
                .cornerRadius(12)
                .padding(.horizontal)
                .onAppear {
                    updateAddress(for: region.center)
                }

                // Live address display
                Text(pinAddress)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                Button("Set This Location") {
                    currentAddress = pinAddress
                    dismiss()
                }
                .disabled(pinAddress.isEmpty)
                .padding()

                Spacer()
            }
            .navigationTitle("Search Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func search(for completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let item = response?.mapItems.first {
                selectedLocation = item
                if let coordinate = item.placemark.coordinate as CLLocationCoordinate2D? {
                    region.center = coordinate
                    updateAddress(for: coordinate)
                }
            }
        }
    }

    private func updateAddress(for coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                pinAddress = [placemark.name, placemark.locality, placemark.administrativeArea]
                    .compactMap { $0 }
                    .joined(separator: ", ")
            } else {
                pinAddress = "Unable to fetch address"
            }
        }
    }
}
