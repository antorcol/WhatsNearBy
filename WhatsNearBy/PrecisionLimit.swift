//
//  PrecisionLimit.swift
//  NoProb
//
//  Created by Anthony Torrero Collins on 4/10/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
