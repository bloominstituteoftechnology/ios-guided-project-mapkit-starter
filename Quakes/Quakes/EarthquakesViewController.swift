//
//  EarthquakesViewController.swift
//  Quakes
//
//  Created by Paul Solt on 10/3/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import MapKit

class EarthquakesViewController: UIViewController {
    
    lazy private var quakeFetcher = QuakeFetcher()
		
	// NOTE: You need to import MapKit to link to MKMapView
	@IBOutlet var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        fetchQuakes()
	}
    
    private func fetchQuakes() {
        quakeFetcher.fetchQuakes { (quakes, error) in
            if let error = error {
                print("Error: \(error)")
            }
            if let quakes = quakes {
                print(quakes.count)
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(quakes)
                }
            }
        }
    }
}
