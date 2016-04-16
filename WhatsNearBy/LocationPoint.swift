//
//  LocationPoint.swift
//  NoProb
//
//  Created by Anthony Torrero Collins on 4/10/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation
import MapKit

class LocationPoint {
    var _locType:LocationType!
    var _coordinates:(Double,Double)
    var _latDeg: CLLocationDegrees!
    var _lonDeg: CLLocationDegrees!
    var _clLocation: CLLocation
    
    init(type:LocationType, long:Double, lat:Double) {
        self._locType = type
        self._coordinates = (long,lat)
        self._lonDeg = self._coordinates.0
        self._latDeg = self._coordinates.1
        
        self._clLocation = CLLocation(latitude: self._latDeg, longitude: self._lonDeg)
    }
    
    var locType : LocationType  {
        get {
            return self._locType
        }
    }
    
    var coordinates: (Double,Double) {
        get {
            return self._coordinates
        }
    }
    
    var cllLocation : CLLocation {
        get {
            return self._clLocation
        }
    }
    
}