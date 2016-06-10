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
        static let teal = UIColor(red: 38/255.0, green:141/255.0, blue:168/255.0, alpha: 1.0)
        static let lightGreyAlpha = UIColor(red: 76/255.0, green:106/255.0, blue:122/255.0, alpha: 0.5)
    }
    
    struct API {
        static let url = "http://curiousedinburgh.org/wp-json/wp/v2/posts?per_page=100"
    }

    struct Table {
        static let blogPostIdentifier = "blogPostCell"
        static let detailCellReuseIdentifier = "detailCellReuseIdentifier"
        static let detailCellVideoReusetIdentifier = "detailCellVideoReuseIdentifier"
    }

    struct SegueIDs {
        static let showBlogPostDetail = "ShowBlogPostDetail"
        static let blogPostDetail =  "BlogPostDetail"
        static let showImage =  "showImage"
    }

    struct ImageIdentifiers {
    
    }
    
    struct Notifications {
        static let SyncComplete = "Sync Complete Notification"
    }
    
    struct Entity {
        static let blogPost =  "BlogPost"
    }
    
    struct View {
        static let defaultCornerRadius = CGFloat(5)
    }
    
}