//
//  ViewController.swift
//  MyFirstCoreLocationProject
//
//  Created by Pierre on 15/11/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    private static let annotID = "azertyuiop"
    
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var mapView: MKMapView!
    
    var firstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if CLLocationManager.locationServicesEnabled() {
            let lm = CLLocationManager()
            lm.delegate = self
            lm.requestWhenInUseAuthorization()
            lm.startUpdatingLocation()
            self.locationManager = lm
        }
        
        /*let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 2, longitude: 32)
        annotation.title = "Test"
        self.mapView.addAnnotation(annotation)*/
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            
            if self.firstTime {
                self.firstTime = false
                
                DispatchQueue.main.async {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location.coordinate
                    annotation.title = "ESGI"
                    self.mapView.addAnnotation(annotation)
                }
            }
            
            
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?)in
                if error == nil {
                    if let placemarks = placemarks {
                        for placemark in placemarks {
                            print(placemark)
                        }
                        
                        self.locationManager?.stopUpdatingLocation()
                    }
                }
            })
        }
        
        /*let location = locations.last
        if location != nil {
            let g = CLGeocoder()
            g.reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) in
                if error == nil {
                    print(placemarks ?? "nil")
                }
            })
        }*/
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ViewController.annotID)
        if annotationView == nil {
            let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: ViewController.annotID)
            pinAnnotation.canShowCallout = true
            pinAnnotation.pinTintColor = UIColor.black
            annotationView = pinAnnotation
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
}

