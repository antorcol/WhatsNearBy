//
//  MyNeighborhoodData.swift
//  NoProb
//
//  Created by Anthony Torrero Collins on 4/8/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation

class MyNeighborhoodData {
    
    private var _address : String!
    private var _longitude : Double!
    private var _latitude : Double!
    private var _location: LocationPoint!
    private var _website: NSURL!
    private var _cityFeature: CityFeature!
    private var _commonName: String!
        
    init() {
        self._address = nil
        self._longitude = nil
        self._latitude = nil
        self._location = nil
        self._website = nil
        self._cityFeature = nil
        self._commonName = nil
    }
    
    convenience init (address:String, longitude:Double, latitude:Double, location:LocationPoint, website:NSURL?, cityFeature:CityFeature, commonName:String) {
        self.init()
        self._address = address
        
        self._longitude = longitude
        self._latitude = latitude
        self._location = location
        if website != nil {
            self._website = website
        } else {
            self._website = NSURL(string: FAILSAFE_SEATTLE_GOV_URL_STR)
        }
        self._cityFeature = cityFeature
        self._commonName = commonName
    }
    
    var address: String {
        get {
            return self._address
        }
    }
    
    var longitude: Double {
        get {
            return self._longitude
        }
    }
    
    var latitude: Double {
        get {
            return self._latitude
        }
    }
    
    var location: LocationPoint {
        get {
            return self._location
        }
    }
    
    var website: NSURL {
        get {
            return self._website
        }
    }
    
    var cityFeature: CityFeature {
        get {
            return self._cityFeature
        }
    }
    
    var commonName: String {
        get {
            return self._commonName
        }
    }
    
}