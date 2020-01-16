//
//  Quake.swift
//  Quakes
//
//  Created by morse on 1/16/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation
import MapKit

class Quake: NSObject, Decodable {
    
    
    // mag
    // place
    // time
    // coordinate
    
    let magnitude: Double
    let place: String
    let time: Date
    let longitude: Double
    let latitude: Double
    
    enum QuakeCodingKeys: String, CodingKey {
        case magnitude = "mag"
        case properties
        case place
        case time
        case longitude
        case latitude
        case geometry
        case coordinates
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: QuakeCodingKeys.self)
        let properties = try container.nestedContainer(keyedBy: QuakeCodingKeys.self, forKey: .properties)
        let geometry = try container.nestedContainer(keyedBy: QuakeCodingKeys.self, forKey: .geometry)
        var coordinates = try geometry.nestedUnkeyedContainer(forKey: .coordinates)
        
        self.magnitude = try properties.decode(
            Double.self, forKey: .magnitude)
        self.place = try properties.decode(String.self, forKey: .place)
        self.time = try properties.decode(Date.self, forKey: .time)
        
        self.longitude = try coordinates.decode(Double.self) // This mutates the contents of the container, it pulls stuff out
        self.latitude = try coordinates.decode(Double.self)
        
        
        super.init()
    }
}
