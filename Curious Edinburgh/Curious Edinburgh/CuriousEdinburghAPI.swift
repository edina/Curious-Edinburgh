      
//  CuriousEdinburghAPI.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 13/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import DATAStack
import Sync

class _CuriousEdinburghAPI {
    
    var dataStack: DATAStack?
    var protocolType:String?
    var domain: String?
    var path: String?
    let queryItems = Constants.API.queryItems
    var url:String?
    
    init() {
  
    }
    
    func syncBlogPosts(completion: (()) -> Void) {
        // Sync posts from API to Core Data model
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var httpProtocol = Constants.HTTP_Protocol.insecure
      
        if let protocolType = defaults.stringForKey("protocolType") where protocolType.lowercaseString == "secure" {
            httpProtocol = Constants.HTTP_Protocol.secure
           
        }
        else if let protocolType = defaults.stringForKey("protocolType") where protocolType.lowercaseString == "insecure" {
            httpProtocol = Constants.HTTP_Protocol.insecure
           
        }
        else
        {
            httpProtocol = Constants.HTTP_Protocol.insecure
        }
        
        
        print(httpProtocol)
        
        //static let path = "/wp-json/wp/v2/posts"
        //static let queryItems = "?per_page=100"
       
        
        // change to extra path
        
        if let extraPath = defaults.stringForKey("extraPath")
        {
            self.path = extraPath + Constants.API.path
        }
        else
        {
            self.path = Constants.API.path ;
        }
        
        print(self.path)
        
        if let domain = defaults.stringForKey("domain"){
            self.url = "\(httpProtocol)\(domain)\(self.path!)\(self.queryItems)"
        } else {
            self.url = "\(Constants.API.default_url)\(self.queryItems)"
        }
        
        print(self.url!)
        
        Alamofire.request(.GET, self.url!).validate().responseJSON { response in
            switch response.result {
            case .Success(let data):
                //                let json = JSON(data).arrayValue
                //                print(json)
                
                // Persist to Core Data
                self.dataStack?.performInNewBackgroundContext { backgroundContext in
                    Sync.changes(
                        data as! [[String : AnyObject]],
                        inEntityNamed: Constants.Entity.blogPost,
                        predicate: nil,
                        parent: nil,
                        inContext: backgroundContext,
                        dataStack: self.dataStack!,
                        completion: { error in
                            print(error)
                            completion()
                    })
                }
            case .Failure(let error):
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.RequestUrlError, object: error)
            }
        }
    
        
    }
    
    func fetchBlogPostsFromCoreData(tour: String)  -> [BlogPost] {
        let request = NSFetchRequest(entityName: Constants.Entity.blogPost)
        let allBlogPosts = (try! self.dataStack?.mainContext.executeFetchRequest(request)) as! [BlogPost]
        self.toursFromBlogPosts(allBlogPosts)
        var index = 0
        var tourPosts:[BlogPost] = []
        for post in allBlogPosts {
            if let tours = post.tours {
                if tours.contains(tour) {
                    tourPosts.append(post)
                }
            }
            index += index
        }
        tourPosts.sortInPlace(self.sortBlogPostsByTourNumberAsc)
        
        return tourPosts
    }
    
    func toursFromBlogPosts(blogPosts: [BlogPost]) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var tours: [String] = []
        
        for post in blogPosts {
            if let postTours = post.tours {
                for tour in postTours {
                    if !tours.contains(tour) {
                        tours.append(tour)
                    }
                }
            }
        }
        
        defaults.setObject(tours, forKey: Constants.UseDefaults.tours)
    }
    
    func sortBlogPostsByTourNumberAsc(post1: BlogPost, post2: BlogPost) -> Bool {
        if let number1 = post1.tourNumber, number2 = post2.tourNumber {
            return Int(number1) < Int(number2)
        }
        return false
    }
}

let curiousEdinburghAPI = _CuriousEdinburghAPI()