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
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeView")
        
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
                    
                    guard let quake = quakes.last else { return }
                    
                    let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                    
                    let region = MKCoordinateRegion(center: quake.coordinate, span: span)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
}

extension EarthquakesViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let quake = annotation as? Quake else {
            fatalError("Only Quakes are supported right now")
        }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeView") as? MKMarkerAnnotationView else {
            fatalError("Missing registered map annotation view")
        }
        // Icon
        annotationView.glyphImage = UIImage(named: "QuakeIcon")
        // Color on magnitude
        if quake.magnitude >= 5 {
            annotationView.markerTintColor = .red
        } else if quake.magnitude >= 3 && quake.magnitude < 5 {
            annotationView.markerTintColor = .orange
        } else {
            annotationView.markerTintColor = .yellow
        }
        
        // Show the popup
        annotationView.canShowCallout = true
        let detailView = QuakeDetailView()
        detailView.quake = quake
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "Segue", sender: nil)
    }
}
