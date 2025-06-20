import CoreLocation
 
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var locationPermissionGranted = false
    @Published var locationPermissionDenied = false
 
    override init() {
        super.init()
        manager.delegate = self
    }
 
    func checkPermission() {
        if CLLocationManager.locationServicesEnabled() {
            let status = manager.authorizationStatus

            switch status {
            case .notDetermined:
                DispatchQueue.main.async {
                    self.manager.requestWhenInUseAuthorization()
                }
            case .restricted, .denied:
                locationPermissionDenied = true
            case .authorizedAlways, .authorizedWhenInUse:
                locationPermissionGranted = true
            @unknown default:
                break
            }
        } else {
            locationPermissionDenied = true
        }
    }
 
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkPermission()
    }
}
