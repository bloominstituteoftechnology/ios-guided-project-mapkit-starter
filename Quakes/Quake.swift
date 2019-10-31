//
//  Quake.swift
//  Quakes
//
//  Created by Dimitri Bouniol Lambda on 1/22/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation

class Quake {
    
    let magnitude: Double
    let place: String
    let time: Date
    let latitude: Double
    let longitude: Double
    
    
    internal init(magnitude: Double, place: String, time: Date, latitude: Double, longitude: Double) {
        self.magnitude = magnitude
        self.place = place
        self.time = time
        self.latitude = latitude
        self.longitude = longitude
    }
}
