//
//  MapPin.swift
//  TP1Geoloc
//
//  Created by etudiant on 16/11/2016.
//  Copyright © 2016 etudiant. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
