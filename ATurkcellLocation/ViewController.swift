//
//  ViewController.swift
//  ATurkcellLocation
//
//  Created by Sefa Aycicek on 4.10.2024.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hello".toLocalize())
        //(UIApplication.shared.delegate as? AppDelegate)?.requestPushNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.prepareCoreLocation()
        self.parepareMap()
    }
    
    func parepareMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func prepareCoreLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
        
    }
    
    func prepareMapRegion(coordiate : CLLocationCoordinate2D) {
        let regionRadius : CLLocationDistance = 2000
        let currentRegion = MKCoordinateRegion(center: coordiate,
                                               latitudinalMeters: regionRadius,
                                               longitudinalMeters: regionRadius)
        mapView.setRegion(currentRegion, animated: true)
    }
    
    func requestLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func addAnnotation(coordinate : CLLocationCoordinate2D ) {
        mapView.removeAnnotations(mapView.annotations)
        let myPoint = MyPoint(title: "Araba", coordinate: coordinate)
        mapView.addAnnotation(myPoint)
        
        prepareMapRegion(coordiate: coordinate)
    }
    
}

extension ViewController : MKMapViewDelegate {
    
}

extension ViewController : CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            self.requestLocation()
            break
        case .authorizedWhenInUse:
            self.requestLocation()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach({ location in
            print("location: \(location.coordinate.latitude) - \(location.coordinate.longitude) ")
            self.addAnnotation(coordinate: location.coordinate)
        })
        
        
        
        //manager.stopUpdatingLocation()
    }
}

class MyPoint : NSObject, MKAnnotation {
    var tite : String?
    var coordinate: CLLocationCoordinate2D
    //var user : User?
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.tite = title
        self.coordinate = coordinate
    }
}

extension String {
    func toLocalize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
