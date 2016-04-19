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
        curiousEdinburghAPI.blogPosts {
            print("Done")
            
            // Test reading object back
            let request = NSFetchRequest(entityName: "BlogPost")
            // request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
            let bps = try! self.dataStack.mainContext.executeFetchRequest(request)
          
            let bp = bps[0] as? BlogPost
            print(bp?.link)
            let content = NSKeyedUnarchiver.unarchiveObjectWithData((bp?.content)!)
            print(content)
            
            
            
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


}

extension UIViewController {
    var dataStack:DATAStack {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).dataStack
    }
}

