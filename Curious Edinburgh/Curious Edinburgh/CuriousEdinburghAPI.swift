
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
    let path = Constants.API.path
    let queryItems = Constants.API.queryItems
    var url:String?
    
    init() {
  
    }
    
    func syncBlogPosts(completion: (()) -> Void) {
        // Sync posts from API to Core Data model
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var httpProtocol = Constants.HTTP_Protocol.insecure
        if let protocolType = self.protocolType where protocolType.lowercaseString == "secure" {
            httpProtocol = Constants.HTTP_Protocol.secure
        }
        
        if let domain = self.domain {
            self.url = "\(httpProtocol)\(domain)\(self.path)\(self.queryItems)"
            defaults.setObject(self.domain, forKey: "lastUsedDomain")
        } else if let domain = defaults.stringForKey("lastUsedDomain"){
            self.url = "\(httpProtocol)\(domain)\(self.path)?per_page=10"
        } else {
            self.url = "\(Constants.API.default_url)"
        }
        
        print(self.url)
        
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
    
    func fetchBlogPostsFromCoreData()  -> [BlogPost] {
        let request = NSFetchRequest(entityName: Constants.Entity.blogPost)
        var blogPosts = (try! self.dataStack?.mainContext.executeFetchRequest(request)) as! [BlogPost]
        blogPosts.sortInPlace(self.sortBlogPostsByTourNumberAsc)
        return blogPosts
    }
    
    func sortBlogPostsByTourNumberAsc(post1: BlogPost, post2: BlogPost) -> Bool {
        if let number1 = post1.tourNumber, number2 = post2.tourNumber {
            return Int(number1) < Int(number2)
        }
        return false
    }
}

let curiousEdinburghAPI = _CuriousEdinburghAPI()