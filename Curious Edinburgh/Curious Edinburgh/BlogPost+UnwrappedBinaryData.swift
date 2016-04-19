//
//  BlogPost+UnwrappedBinaryData.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 19/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import SwiftyJSON

extension BlogPost {
    
    var titleAsString: String {
        get {
            if let title = NSKeyedUnarchiver.unarchiveObjectWithData(self.title!){
                let titleJson = JSON(title)
                return titleJson["rendered"].stringValue
            }
            return "";
        }
    }
}
