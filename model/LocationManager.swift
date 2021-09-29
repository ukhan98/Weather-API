//
//  LocationManager.swift
//  USMAN_Weather
//
//  Created by mac owner on 2020-11-26.
//

import Foundation
import CoreLocation
import Contacts
import MapKit

class LocationManager: NSObject, ObservableObject{
    @Published var city : String? = ""
    @Published var lat: Double = 0.0
    @Published var lng: Double = 0.0
    @Published var state : String? = ""
    
    private let manager = CLLocationManager()
    private var lastKnownLocation: CLLocationCoordinate2D?
    private let regionRadius: CLLocationDistance = 300
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        
        self.start()
    }
    
    func start(){
        manager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()){
            manager.startUpdatingLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.requestLocation()
        case .authorizedAlways:
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            manager.requestLocation()
        case .restricted:
            break
        case .denied:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.lastKnownLocation = locations.first?.coordinate
        
        if locations.last != nil{
            print(#function, "location: \(locations)")
            self.lat = (locations.last!.coordinate.latitude)
            self.lng = (locations.last!.coordinate.longitude)
        }
        
        self.lat = (manager.location?.coordinate.latitude)!
        self.lng = (manager.location?.coordinate.longitude)!
        setCity()
    }
    
    func setCity() {
        //reverse geocoding
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.lat, longitude: self.lng)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: {placemarks, error -> Void in
            guard let placemark = placemarks?.first else{
                print(#function, "Unable to obtain placemark from LatLng")
                return
            }
            
//            let postalCode = placemark.postalCode
            self.city = placemark.locality
            self.state = placemark.administrativeArea
            //take home - check different properties of placemark such as subThroughFare, locality, etc.
            
            //successfully obtained the placemark
        })
    }
    func getCity ()-> String? {
        return city
    }
    
    
    func getCoordinates(address: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void){
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address){(placemarks, error) in
            if error == nil {
                if let placemark = placemarks?.first{
                    let location = placemark.location!
                    
                    print(#function, "location: ", location)
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
}
