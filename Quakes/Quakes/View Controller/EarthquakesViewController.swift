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
		
    //MARK: - Properties
    var quakeFetcher = QuakeFetcher()
    
    //MARK: - Outlets
    
	// NOTE: You need to import MapKit to link to MKMapView
	@IBOutlet var mapView: MKMapView!
    
	//MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
        quakeFetcher.fetchQuakes { (quakes, error) in
            if let error = error{
                print("Error fetching quakes: \(error)")
            }
            guard let quakes = quakes else {return}
            
            print(quakes.count)
        }
	}
}
