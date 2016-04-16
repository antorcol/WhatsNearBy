//
//  SecondViewController.swift
//  NoProb
//
//  Created by Anthony Torrero Collins on 4/4/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit
import MapKit

class SettingsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var featureArray : [String]!
    var selectedItem: String!
    
    @IBOutlet weak var cityFeaturePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityFeaturePicker.delegate = self
        cityFeaturePicker.dataSource = self
        cityFeaturePicker.showsSelectionIndicator = true
        featureArray = CityFeature.ALL_ITEMS
//        selectedItem = CityFeature.HighSchools.rawValue

        
        //TODO
//        var defaultRowIndex = find(items,itemAtDefaultPosition!)
//        if(defaultRowIndex == nil) { defaultRowIndex = 0 }
//        mPicker.selectRow(defaultRowIndex!, inComponent: 0, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        var counter:Int = 0
        for item in featureArray {
            if selectedItem == item {
                cityFeaturePicker.selectRow(counter, inComponent: 0, animated: true)
                break
            }
            counter = counter+1
        }
    }

    //MARK: Picker Support
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return  1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return featureArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return featureArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = featureArray[row]
        if let homeTab = self.tabBarController?.viewControllers![0] as? HomeVC {
            homeTab.currentCityFeature = CityFeature(rawValue: selectedItem)!
            homeTab.cityFeatureChanged = true
            
            //remove pins
            homeTab.workingMap.annotations.forEach {
                if !($0 is MKUserLocation) {
                    homeTab.workingMap.removeAnnotation($0)
                }
            }

            
        }
        
    }
    
}

