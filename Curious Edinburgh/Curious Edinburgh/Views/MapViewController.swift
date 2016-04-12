//
//  MapViewController.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 11/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {


    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            // Set delegate for Map
            mapView.delegate = self
        }
    }
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.showsUserLocation = true
        
        self.initialMapLocation()
    }

    func initialMapLocation() {
        
        let location = CLLocationCoordinate2D(
            latitude: 55.953252,
            longitude: -3.188267
        )
        
        let span = MKCoordinateSpanMake(0.2, 0.2)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mapView.setRegion(region, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
