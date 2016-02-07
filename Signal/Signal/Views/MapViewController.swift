//
//  MapViewController.swift
//  Signal
//
//  Created by Sam Son on 2/7/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var latitude: NSString = ""
    var longitude: NSString = ""
    let regionRadius: CLLocationDistance = 1000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Signal Location"
        mapView.delegate = self
        
        let numberFormatter = NSNumberFormatter()
        let numberLatitude = numberFormatter.numberFromString(latitude as String)
        let numberLongitude = numberFormatter.numberFromString(longitude as String)
        let currentLocation = CLLocation.init(latitude: numberLatitude!.doubleValue, longitude: numberLongitude!.doubleValue)
        centerMapOnLocation(currentLocation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 1.0, regionRadius * 1.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "Signal from here"
        
        mapView.addAnnotation(annotation)
    }
    
}
