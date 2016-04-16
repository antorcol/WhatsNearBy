//
//  FirstViewController.swift
//  NoProb
//
//  Created by Anthony Torrero Collins on 4/4/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit
import MapKit

class HomeVC: UIViewController, MKMapViewDelegate {
    
    //soda client
    let sodaClient =  SODAClient(domain: "data.seattle.gov", token: "DO7YZXWWiGN0H2Wes3EmLR0GP")
    var workingData: [[String: AnyObject]]! = []
    var currentCityFeature: CityFeature = CityFeature.HeritageTrees
    var cityFeatureChanged: Bool = false
    
    //hold structured result of a q
    var cityLocationData: [MyNeighborhoodData] = [MyNeighborhoodData]()
    
    //mapping
    let locationManager = CLLocationManager() //required for mapping
    let regionRadius: CLLocationDistance = 5000 //meters TODO: variable
    
        
    //MARK: outlets
    @IBOutlet weak var workingMap: MKMapView!

    
    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up map
        self.workingMap.delegate = self
        
        
        //initial settings tab value
        if let settingsTab = self.tabBarController?.viewControllers![1] as? SettingsVC {
            settingsTab.selectedItem = currentCityFeature.rawValue
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.locationAuthStatus()
        
        print("For City Feature: \(currentCityFeature).")
        
        if(cityFeatureChanged) {

            cityFeatureChanged = false
            cityLocationData.removeAll()
            
            //get soda data
            self.getFeatureData({  () -> () in
                for add in self.cityLocationData {
                    self.getPlacemarkFromLocation(add.location, title: add.commonName, subTitle: add.cityFeature.rawValue)
                }
            })
            
            
        }
    }

    
    //MARK: Map Utility
    func locationAuthStatus() {
        //get permission from the user to get user location
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            workingMap.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //scope in on my location
    func centerMapLocation(location:CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        workingMap.setRegion(coordinateRegion, animated: true)
    }
    
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let myLocation = userLocation.location {
            centerMapLocation(myLocation)
        }
    }
    
    func getPlacemarkFromLocation(address: LocationPoint, title:String, subTitle:String) {
        
        CLGeocoder().reverseGeocodeLocation(address.cllLocation) {  (placemarks: [CLPlacemark]?, error:NSError?) -> Void in
            if let marks = placemarks where marks.count > 0 {
                if let loc = marks[0].location {
                    self.createAnnotationForLocation(loc, title: title, subTitle: subTitle)
                }
            }
        }
    }

    //add the location to the map
    func createAnnotationForLocation(location: CLLocation, title:String, subTitle:String) {
        let cityFeature = LocationAnnotation(coordinate: location.coordinate, title: title, subTitle: subTitle)
        
        workingMap.addAnnotation(cityFeature)
    }
    
    
    //MARK: SODA Utility
    func getFeatureData(completed:DownloadComplete) {
        
        let stuffNear = sodaClient.queryDataset("3c4b-gdxv")
        
        stuffNear.filterColumn("city_feature", currentCityFeature.rawValue).get({ results in
        
            switch results {
            case .Dataset(let stuffNearData):

                self.workingData = stuffNearData
                for rawDataItem in stuffNearData {
                    let structuredItem = rawDataItem
                    if structuredItem.count > 0 {

                        let oneMyNeigh: MyNeighborhoodData!
                        
                        var tmpAddress: String!
                        if let possibleAddr = structuredItem["address"] as? String {
                            tmpAddress = possibleAddr
                        } else {
                            tmpAddress = "No address listed"
                        }
                        
                        var tmpLongitude:Double!
                        if let tmpLongitudeStr:String = structuredItem["longitude"] as? String {
                            tmpLongitude = Double(tmpLongitudeStr)?.roundToPlaces(7)
                        }
                        
                        var tmpLatitude:Double!
                        if let tmpLatitudeStr = structuredItem["latitude"] as? String {
                            tmpLatitude = Double(tmpLatitudeStr)?.roundToPlaces(7)
                        }
                        
                        //the data.seattle.gov spec for location has the same lat and long as are 
                        //  passed in separately. But processing just in case.
                        var tmpLocation:LocationPoint!
                        if let tmpLocationDict = structuredItem["location"] as? Dictionary<String,AnyObject> {
                            var tmpLocType:LocationType!
                            if let locType = tmpLocationDict["type"] as? String {
                                tmpLocType = LocationType(rawValue: locType)
                            }
                            
                            var latCoordStr:Double!
                            var logCoordStr:Double!
                            
                            if let coords = tmpLocationDict["coordinates"] as? [Double] {
                                latCoordStr = coords[0].roundToPlaces(7)
                                logCoordStr = coords[1].roundToPlaces(7)
                                
                            } else {
                                //just in case
                                    logCoordStr = tmpLongitude
                                    latCoordStr = tmpLatitude
                            }
                            
                            tmpLocation = LocationPoint(type: tmpLocType, long: latCoordStr, lat: logCoordStr)
                            
                        }
                        
                        var tmpWebSiteUrl: NSURL!
                        if let tmpWebSiteName:String = structuredItem["website"] as? String {
                            if let validURL: NSURL = NSURL(string: tmpWebSiteName) {
                                tmpWebSiteUrl = validURL
                            } else {
                                tmpWebSiteUrl = nil
                            }
                        }
                        
                        var tmpCityFeature:CityFeature = CityFeature.Cemeteries
                        if let tmpCityFeatureName:String = structuredItem["city_feature"] as? String {
                            tmpCityFeature = CityFeature(rawValue: tmpCityFeatureName)!
                        }
                        
                        var tmpCommonName: String!
                        if let possibleCommonName = structuredItem["common_name"] as? String {
                            tmpCommonName = possibleCommonName
                        } else {
                            tmpCommonName = "No common name"
                        }
                       
                        print("In getFeatureData: \(tmpCommonName)")
                        
                        oneMyNeigh = MyNeighborhoodData(address: tmpAddress, longitude: tmpLongitude, latitude: tmpLatitude, location: tmpLocation, website: tmpWebSiteUrl, cityFeature: tmpCityFeature, commonName: tmpCommonName)
                        
                        self.cityLocationData.append(oneMyNeigh)
                        
                    }
                    
                }
                
                
            case.Error(let errData):
                
                //Create the AlertController
                let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Error Refreshing: \(errData.debugDescription).", preferredStyle: .Alert)
                
//                //Create and add the Cancel action
//                let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
//                    //Do some stuff
//                }

                self.presentViewController(actionSheetController, animated: true, completion: nil)
            }
            
        
            completed()
        
        })
        
        //save -- do you need the data later?
        let tmp = self.workingData
        
    }
    
    
    
}

