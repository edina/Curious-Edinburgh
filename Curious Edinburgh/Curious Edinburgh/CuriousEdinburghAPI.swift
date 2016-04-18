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
    
    func blogPosts(completion: (()) -> Void) {
        // Return some posts
       
 
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
                        inEntityNamed: "BlogPost",
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
    
   }

let curiousEdinburghAPI = _CuriousEdinburghAPI()