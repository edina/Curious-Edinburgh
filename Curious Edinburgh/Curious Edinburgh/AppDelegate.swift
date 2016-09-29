//
//  AppDelegate.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 11/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import CoreData
import DATAStack
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
  
    
    var dataStack: DATAStack = {
        let dataStack = DATAStack(modelName: "Curious_Edinburgh")
        
        return dataStack
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        curiousEdinburghAPI.dataStack = self.dataStack
     
        curiousEdinburghAPI.syncBlogPosts {
       
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.SyncComplete, object: nil)

            
      //    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.changeNotification(_:)), name:Constants.Notifications.SyncComplete, object: nil)

            
            print("Initial sync completed")
        }
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        self.dataStack.persistWithCompletion(nil)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        self.dataStack.persistWithCompletion(nil)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    // MARK:- Url Scheme
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        // Handle urlscheme to retrieve survey id and redirect to HomeViewController
   //     let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      //  let homeViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        
        if let urlComponents = NSURLComponents(string: url.absoluteString), host = urlComponents.host, path = urlComponents.path ,  queryItems = urlComponents.queryItems  {
            let defaults = NSUserDefaults.standardUserDefaults()
          //  homeViewController.domain = host
            defaults.setObject(host, forKey: "domain")
          //  homeViewController.path = path
            
            defaults.setObject(path, forKey: "extraPath")
            
            for item in queryItems {
                if item.name == "protocol" {
                    //homeViewController.protocolType = item.value
                    defaults.setObject(item.value, forKey: "protocolType")
                    
                }
                if item.name == "tour" {
                    //homeViewController.tourName = item.value
                    //Constants.defaultTour = item.value!
                    
                    defaults.setObject(item.value!, forKey: Constants.UseDefaults.tour)
                    print(item.value)
                    
                 
            
                }
            }
            
            
                
                print("launch from URL")
            

        }
        
       // let rootViewController = self.window!.rootViewController as! UINavigationController
       //  rootViewController.setViewControllers([homeViewController], animated: true)
      
        
        curiousEdinburghAPI.syncBlogPosts {
          
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.SyncComplete, object: nil)
            
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.TourSelected, object: nil)
           
            print("Launch URL sync completed")
        
        }

            
        return true
    }


}

extension UIViewController {
    var dataStack:DATAStack {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).dataStack
    }
}

