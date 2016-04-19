//
//  Constants.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 13/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
 
    struct Colour {
        static let lightGrey = UIColor(red: 76/255.0, green:106/255.0, blue:122/255.0, alpha: 1.0)
        static let lightGreyAlpha = UIColor(red: 76/255.0, green:106/255.0, blue:122/255.0, alpha: 0.5)
    }
    
    struct API {
        static let url = "http://ec2-52-50-23-66.eu-west-1.compute.amazonaws.com/wp-json/wp/v2/posts"
    }

    struct Table {
        static let blogPostIdentifier = "blogPostCell"
    }

    struct SegueIDs {
     
    }

    struct ImageIdentifiers {
    
    }
    
}