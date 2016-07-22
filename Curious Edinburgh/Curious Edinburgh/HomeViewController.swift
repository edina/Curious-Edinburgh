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
    
    @IBAction func shareButtonSelected(sender: UIBarButtonItem) {
        let title = "Science Tour"
        var text = Constants.ShareSheet.tourShareString
        text = text.stringByReplacingOccurrencesOfString("<tour_or_stop_name>", withString: title)

        
        if let url = NSURL(string: "\(Constants.ShareSheet.urlBase)category/science") {
            let objectsToShare = [text, url]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController!.navigationBar.barTintColor = Constants.Colour.teal

        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PagingMenuControllerDelegate
    
    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
        
    }
    
    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
        
    }
}

