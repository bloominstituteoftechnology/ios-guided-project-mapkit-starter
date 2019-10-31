//
//  QuakeFetcher.swift
//  Quakes
//
//  Created by Paul Solt on 1/16/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation
import MapKit

extension CoordinateRegion {
    fileprivate var queryItems: [URLQueryItem] {
        return [
            URLQueryItem(name: "minlongitude", value: String(origin.longitude)),
            URLQueryItem(name: "minlatitude", value: String(origin.latitude)),
            URLQueryItem(name: "maxlongitude", value: String(origin.longitude + size.width)),
            URLQueryItem(name: "maxlatitude", value: String(origin.latitude + size.height))
        ]
    }
}

enum QuakeError: Int, Error {
	case invalidURL
	case noDataReturned
	case dateMathError
	case decodeError
}

class QuakeFetcher {
	let baseURL = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query")!
	let dateFormatter = ISO8601DateFormatter()
	
	func fetchQuakes(in region: MKMapRect? = nil,
                     completion: @escaping ([Quake]?, Error?) -> Void) {
		
		let endDate = Date()
		var dateComponents = DateComponents()
		dateComponents.calendar = Calendar.current
		dateComponents.day = -7 // -365 * 10 // 7 days in the past
		
		guard let startDate = Calendar.current.date(byAdding: dateComponents, to: endDate) else {
			print("Date math error")
			completion(nil, QuakeError.dateMathError)
			return
		}
		
		let interval = DateInterval(start: startDate, end: endDate)
		fetchQuakes(from: interval, completion: completion)
	}
	
	func fetchQuakes(from dateInterval: DateInterval,
                     in region: MKMapRect? = nil,
					 completion: @escaping ([Quake]?, Error?) -> Void) {
		
		
		var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
		
		// startTime, endTime, format
		let startTime = dateFormatter.string(from: dateInterval.start)
		let endTime = dateFormatter.string(from: dateInterval.end)
		
		var queryItems = [
			URLQueryItem(name: "starttime", value: startTime),
			URLQueryItem(name: "endtime", value: endTime),
			URLQueryItem(name: "format", value: "geojson")
		]
        
        if let region = region {
            let coordinates = CoordinateRegion(mapRect: region)
            queryItems.append(contentsOf: coordinates.queryItems)
        }
		
		urlComponents?.queryItems = queryItems
		
		guard let url = urlComponents?.url else {
			print("Error creating URL from components")
			completion(nil, QuakeError.invalidURL)
			return
		}
		
		URLSession.shared.dataTask(with: url) { (data, _, error) in
			if let error = error {
				print("Error fetching quakes: \(error)")
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
				return
			}
			
			guard let data = data else {
				print("No data")
                
                DispatchQueue.main.async {
                    completion(nil, QuakeError.noDataReturned)
                }
				return
			}
			
			print(data)
			
			do {
				let decoder = JSONDecoder()
				decoder.dateDecodingStrategy = .millisecondsSince1970
				
//				let quakeResults =
				
                DispatchQueue.main.async {
//                    completion(<# quakeResults #>, nil)
                }
				
			} catch {
				print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
			}
			
		}.resume()
	}
}
