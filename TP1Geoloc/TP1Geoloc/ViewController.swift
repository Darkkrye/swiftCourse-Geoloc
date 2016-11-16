//
//  ViewController.swift
//  TP1Geoloc
//
//  Created by etudiant on 16/11/2016.
//  Copyright © 2016 etudiant. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, APIControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    static let annotID = "annotationID"
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?

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
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        APIController.sharedInstance.delegate = self
        APIController.sharedInstance.getInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func returnedInformation(data: Data, statusCode: Int) {
        let json = JSON(data: data)
        
        for i in 0..<json.count {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(json[i]["coordinate"]["lat"].stringValue)!, longitude: Double(json[i]["coordinate"]["lon"].stringValue)!)
            
            
            if json[i]["title"].stringValue != "" {
                annotation.title = json[i]["title"].stringValue
            }
            
            self.mapView.addAnnotation(annotation)
        }
        
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ViewController.annotID)
        if annotationView == nil {
            
            let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: ViewController.annotID)
            pinAnnotation.canShowCallout = true
            
            if annotation.title! == nil {
                pinAnnotation.pinTintColor = UIColor.black
            } else {
                pinAnnotation.pinTintColor = UIColor.green
            }
            
            annotationView = pinAnnotation
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    /*func putAnnotationFromAddress(pAddress: String, pZipCode: String, pCity: String, pImageLink: String, pName:String, pPseudo:String, pIndex:Int) {
        let address = pAddress + ", " + pZipCode + " " + pCity
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                //print("Error: ", error)
            }
            
            if let placemark = placemarks?.first {
                
                let thumbnail = JPSThumbnail()
                
                var myImage: UIImage
                if let url = NSURL(string: pImageLink), let data = NSData(contentsOf: url as URL) {
                    myImage = UIImage(data: data as Data)!
                    
                    thumbnail.image = myImage
                    thumbnail.title = pName
                    thumbnail.subtitle = pPseudo
                    thumbnail.coordinate = (placemark.location?.coordinate)!
                }
                
                self.mapView.addAnnotation(JPSThumbnailAnnotation(thumbnail: thumbnail))
            }
        });
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.conforms(to: JPSThumbnailAnnotationProtocol.self)) {
            return (annotation as! JPSThumbnailAnnotationProtocol).annotationView(inMap: mapView)
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if (view.conforms(to: JPSThumbnailAnnotationViewProtocol.self)) {
            (view as! JPSThumbnailAnnotationViewProtocol).didDeselectAnnotationView(inMap: mapView)
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if (view.conforms(to: JPSThumbnailAnnotationViewProtocol.self)) {
            
            (view as! JPSThumbnailAnnotationViewProtocol).didSelectAnnotationView(inMap: mapView)
        }
    }*/
}

