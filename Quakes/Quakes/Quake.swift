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
    
    enum QuakeCodingKeys: String, CodingKey {
        case magnitude = "mag"
        case properties
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: QuakeCodingKeys.self)
        let properties = try container.nestedContainer(keyedBy: QuakeCodingKeys.self, forKey: .properties)
        
        self.magnitude = 0
        
        super.init()
    }
}
