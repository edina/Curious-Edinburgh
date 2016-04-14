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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController!.navigationBar.barTintColor = Constants.Colour.lightGrey

        
        let mapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        mapViewController.title = "Map"
        let tableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TableViewController") as! TableViewController
        tableViewController.title = "List"
        
        let viewControllers = [mapViewController, tableViewController]
        
        let options = PagingMenuOptions()
        options.menuHeight = 50
        options.scrollEnabled = false
        options.menuDisplayMode = .SegmentedControl
        options.backgroundColor = Constants.Colour.lightGrey
        options.selectedBackgroundColor = Constants.Colour.lightGrey
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

