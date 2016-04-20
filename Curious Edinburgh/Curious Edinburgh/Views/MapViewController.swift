//
//  MapViewController.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 11/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import CoreData
import DATAStack
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var blogPosts = [NSManagedObject]()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            // Set delegate for Map and location manager
            mapView.delegate = self
            locationManager.delegate = self
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMapLocation()
        self.fetchNewData()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if(status != CLAuthorizationStatus.NotDetermined) {
             mapView.showsUserLocation = true
        }
    }
    
    func fetchNewData() {
        curiousEdinburghAPI.syncBlogPosts {
            self.fetchCurrentObjects()
        }
    }
    
    func fetchCurrentObjects() {
        
        self.blogPosts = curiousEdinburghAPI.fetchBlogPostsFromCoreData()
        for item in self.blogPosts {
            if let post = item as? BlogPost {
                mapView.addAnnotation(post)
            }
        }
    }
    
    func initialMapLocation() {
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        let location = CLLocationCoordinate2D(
            latitude: 55.953252,
            longitude: -3.188267
        )
        
        let span = MKCoordinateSpanMake(0.2, 0.2)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mapView.setRegion(region, animated: true)
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.SegueIDs.blogPostDetail {
            if let destination = segue.destinationViewController as? BlogPostDetailViewController {
                
                destination.modalPresentationStyle = .Custom
                if let annotationView = sender as? MKAnnotationView {
                    if let post = annotationView.annotation as? BlogPost{
                        destination.blogPost = post
                    }
                }
            }
        }
    }
    
    // MARK: - MapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? BlogPost {
            let identifier = "pin"
            let defaultItemThumbnail = UIImage(named: "DefaultAnnotationThumbnail")
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.leftCalloutAccessoryView = UIImageView(image: defaultItemThumbnail)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegueWithIdentifier(Constants.SegueIDs.blogPostDetail, sender: view)
    }
}
