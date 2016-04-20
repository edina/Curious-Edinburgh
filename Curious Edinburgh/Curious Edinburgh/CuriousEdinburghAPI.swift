//
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
    
    init() {
  
    }
    
    func syncBlogPosts(completion: (()) -> Void) {
        // Sync posts from API to Core Data model
        
        Alamofire.request(.GET, Constants.API.url).validate().responseJSON { response in
            switch response.result {
            case .Success(let data):
                let json = JSON(data).arrayValue
                print(json)
                /* if let id = json[0]["id"].int {
                 //Now you got your value
                 print(id)
                 }*/
                
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
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func fetchBlogPostsFromCoreData()  -> [NSManagedObject] {
        let request = NSFetchRequest(entityName: Constants.Entity.blogPost)
        return (try! self.dataStack?.mainContext.executeFetchRequest(request)) as! [NSManagedObject]
    }
    
}

let curiousEdinburghAPI = _CuriousEdinburghAPI()