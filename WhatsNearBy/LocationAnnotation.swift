//
//  LocationAnnotation.swift
//  NoProb
//
//  Created by Anthony Torrero Collins on 4/10/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation
import MapKit


class LocationAnnotation: NSObject, MKAnnotation {
    
    var coordinate = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    
    init(coordinate:CLLocationCoordinate2D, title:String, subTitle:String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subTitle
    }
    
}