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
import AlamofireImage


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    var blogPosts = [BlogPost]()
    let locationManager = CLLocationManager()
    var mapOverlays:[MKOverlay] = []
    
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var showHideRoutingButton: UIButton!
    @IBOutlet var mapViewPanGesture: UIPanGestureRecognizer!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            // Set delegate for Map and location manager
            mapView.delegate = self
            locationManager.delegate = self
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapViewPanGesture.delegate = self
        
        // Listen for sync completion notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.changeNotification(_:)), name:Constants.Notifications.SyncComplete, object: nil)

        self.initialMapLocation()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if(status != CLAuthorizationStatus.NotDetermined) {
             mapView.showsUserLocation = true
        }
    }
    
    @IBAction func setMapToUserLocation(sender: UIButton) {
        // TODO: Check user location is within survey bounding box
        let image = UIImage(named: "CurrentLocationIconSelected")
        currentLocationButton.setImage(image, forState: .Normal)
        mapView.setCenterCoordinate(locationManager.location!.coordinate, animated: true)
    }
    
    @IBAction func mapDrag(sender: UIPanGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Changed){
            let image = UIImage(named: "CurrentLocationIcon")
            if let buttonImage = currentLocationButton.currentImage {
                if buttonImage != image {
                    currentLocationButton.setImage(image, forState: .Normal)
                }
            }
        }
    }
    
    @IBAction func showHideRoute(sender: UIButton) {
        if self.mapView.overlays.count > 0 {
            let image = UIImage(named: "RoutingInfoOff")
            showHideRoutingButton.setImage(image, forState: .Normal)
            self.mapView.removeOverlays(self.mapView.overlays)
        } else {
            let image = UIImage(named: "RoutingInfoOn")
            showHideRoutingButton.setImage(image, forState: .Normal)
            for overlay in mapOverlays {
                self.mapView.addOverlay(overlay)
            }
        }
    }
    
    func fetchCurrentObjects() {
        
        self.blogPosts = curiousEdinburghAPI.fetchBlogPostsFromCoreData()
        for post in self.blogPosts {
            mapView.addAnnotation(post)
        }
        var count = 0
        repeat {
            self.getDirections(blogPosts[count].coordinate, toLocationCoord: blogPosts[count+1].coordinate)
            count = count + 1
        } while count < blogPosts.count - 1
        
    }
    
    func initialMapLocation() {
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        let location = CLLocationCoordinate2D(
            latitude: 55.953252,
            longitude: -3.1965
        )
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
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
    
    // MARK: - Notification
    
    func changeNotification(notification: NSNotification) {
        // Sync with API is complete so we can populate map
        self.fetchCurrentObjects()
    }
    
    // MARK: - MapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? BlogPost {
            let identifier = "pin"
            let defaultItemThumbnail = UIImage(named: "DefaultAnnotationThumbnail")
            
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                
                let imageView = UIImageView(image: defaultItemThumbnail)
                if let images = annotation.images{
                    let defaultImage = images[0]
                    let URL = NSURL(string: defaultImage)!
                    imageView.af_setImageWithURL(URL, placeholderImage: defaultItemThumbnail)
                }
                
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.leftCalloutAccessoryView = imageView
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
                let mapMarker = customMarker(annotation)
                view.image = mapMarker
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegueWithIdentifier(Constants.SegueIDs.blogPostDetail, sender: view)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = self.view.tintColor
        renderer.lineWidth = 2
        return renderer
    }
    
    func customMarker(post: BlogPost) -> UIImage {
        let text = post.tourNumber
        let marker = UIImage(named:"CustomMapMarker")
        
        // Setup the font specific variables
        let textColor = UIColor.whiteColor()
        let fontSize:CGFloat = 11.0
        let textFont = UIFont.boldSystemFontOfSize(fontSize)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            //        NSStrokeColorAttributeName: UIColor.blackColor(),
            //        NSStrokeWidthAttributeName: 3.0
        ]
        
        if let marker = marker, text = text {
        
            // Create bitmap based graphics context
            UIGraphicsBeginImageContextWithOptions(marker.size, false, 0.0)
            
            //Put the image into a rectangle as large as the original image.
            marker.drawInRect(CGRectMake(0, 0, marker.size.width, marker.size.height))
            
            // Our drawing bounds
            let drawingBounds = CGRectMake(0.0, 0.0, marker.size.width, marker.size.height/3)
            
            let textSize = text.sizeWithAttributes([NSFontAttributeName:textFont])
            let textRect = CGRectMake(drawingBounds.size.width/2 - textSize.width/2, drawingBounds.size.height/2 - textSize.height/2,
                                      textSize.width, textSize.height)
            
            text.drawInRect(textRect, withAttributes: textFontAttributes)
            
            // Get the image from the graphics context
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
        }
        
        return marker!
    }
    
    func getDirections(fromLocationCoord: CLLocationCoordinate2D, toLocationCoord: CLLocationCoordinate2D) {
        let fromLocationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: fromLocationCoord, addressDictionary: nil))
        let toLocationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: toLocationCoord, addressDictionary: nil))
        
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.transportType = .Walking
        directionsRequest.source = fromLocationMapItem
        directionsRequest.destination = toLocationMapItem
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculateDirectionsWithCompletionHandler { (directionsResponse, error) -> Void in
            if let error = error {
                print("Error getting directions: \(error.localizedDescription)")
            } else {
                if let response = directionsResponse {
                    let route = response.routes[0]
                    self.mapOverlays.append(route.polyline)
                }
            }
        }
    }

    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
