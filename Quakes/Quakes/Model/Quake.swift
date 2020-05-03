//
//  Quake.swift
//  Quakes
//
//  Created by FGT MAC on 5/3/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation


class Quake: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case magnitude = "mag"
        case time
        case place
        case latitude
        case longitude
        //Second level
        case properties
        //Third level
        case geometry
        //4th level deep
        case coordinates
    }
    
    let magnitude: Double?
    let time: Date
    let place: String
    let latitude: Double
    let longitude: Double
    
    required init(from decoder: Decoder) throws {
        //Containers to pull out data
        //Fist level within the JSON
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //Second level inside the first "container"
        let properties = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .properties)
        //3rd level inside the first "properties"
        let geometry = try properties.nestedContainer(keyedBy: CodingKeys.self, forKey: .geometry)
        //4th level inside the first "geometry"
        var coordinates = try geometry.nestedUnkeyedContainer(forKey: .coordinates)
        
        
        //Extract our properties
        self.magnitude = try? properties.decode(Double.self, forKey: .magnitude)//If nil it wont crash because of the try?
        self.time = try properties.decode(Date.self, forKey: .time)
        self.place = try properties.decode(String.self, forKey: .place)
        //In the API Docs shows the following order in the unkey JSON:
        self.latitude = try coordinates.decode(Double.self)
        self.longitude = try coordinates.decode(Double.self)
    }
}
