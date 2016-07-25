//
//  HomeViewController.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 14/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import PagingMenuController

class HomeViewController: UIViewController, PagingMenuControllerDelegate {
    
    var protocolType:String?
    var domain:String?
    var tourName:String?
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBAction func shareButtonSelected(sender: UIBarButtonItem) {
        let title = getTitle()
        
        var text = Constants.ShareSheet.tourShareString
        text = text.stringByReplacingOccurrencesOfString(Constants.ShareSheet.tourOrStopPlaceholder, withString: title)
        
        let category = title.lowercaseString.stringByReplacingOccurrencesOfString(" tour", withString: "")
        
        if let url = NSURL(string: "\(Constants.ShareSheet.urlBase)category/\(category)") {
            let objectsToShare = [text, url]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController!.navigationBar.barTintColor = Constants.Colour.teal
        
        self.setTitleToTourName()
        
        // Listen for tour selected notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tourSelectedNotification(_:)), name:Constants.Notifications.TourSelected, object: nil)

        
        let mapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        mapViewController.title = "Map"
        mapViewController.protocolType = self.protocolType
        mapViewController.domain = self.domain
        mapViewController.tourName = self.tourName
        let tableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TableViewController") as! TableViewController
        tableViewController.title = "List"
        
        let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
        aboutViewController.title = "About"
        
        
        let viewControllers = [mapViewController, tableViewController, aboutViewController]
        
        let options = PagingMenuOptions()
        options.menuHeight = 50
        options.scrollEnabled = false
        options.menuDisplayMode = .SegmentedControl
        options.backgroundColor = Constants.Colour.teal
        options.selectedBackgroundColor = Constants.Colour.teal
        options.selectedTextColor = UIColor.whiteColor()
        
        options.menuPosition = .Bottom
        
        options.menuItemMode = .Underline(height: 3, color: UIColor.whiteColor(), horizontalPadding: 0, verticalPadding: 0)
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.delegate = self
        pagingMenuController.setup(viewControllers: viewControllers, options: options)
    }
    
    func setTitleToTourName() {
        let defaults = NSUserDefaults.standardUserDefaults()
        self.tourName = defaults.stringForKey(Constants.UseDefaults.tour)
        
        self.navBar.title = getTitle()
    }
    
    func getTitle() -> String {
        var title = Constants.defaultTour
        
        if let tourName = self.tourName {
            title = tourName
        }
        
        title = title.stringByReplacingOccurrencesOfString("_stop", withString: "")
        title = title.stringByReplacingOccurrencesOfString("_", withString: " ").capitalizedString
        
        return title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PagingMenuControllerDelegate
    
    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
        
    }
    
    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
        
    }
    
    // MARK: - Notifications
    func tourSelectedNotification(notification: NSNotification) {
        self.setTitleToTourName()
    }
}

