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
        static let path = "/wp-json/wp/v2/posts"
        static let queryItems = "?per_page=100"
        static let default_url = "\(HTTP_Protocol.insecure)curiousedinburgh.org\(path)\(queryItems)"
    }
    
    struct HTTP_Protocol {
        static let insecure = "http://"
        static let secure = "https://"
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
        static let defaultThumbnail = "DefaultTableVIewThumbnail"
        static let defaultAnnotationThumbnail = "DefaultAnnotationThumbnail"
        static let currentLocationIcon = "CurrentLocationIcon"
        static let currentLocationIconSelected = "CurrentLocationIconSelected"
        static let routingInfoOn = "RoutingInfoOn"
        static let routingInfoOff = "RoutingInfoOff"
        static let tourNumber = "TourNumber"
    }
    
    struct Notifications {
        static let SyncComplete = "Sync Complete Notification"
        static let RequestUrlError = "URL Request Error Notification"
        static let TourSelected = "TourSelected"
    }
    
    struct Entity {
        static let blogPost =  "BlogPost"
    }
    
    struct View {
        static let defaultCornerRadius = CGFloat(5)
    }
    
    struct ShareSheet {
        static let urlBase = "http://curiousedinburgh.org/"
        static let twitterAccount = "@curiousedi"
        static let hashtag = "#curiousedinburgh"
        static let tourOrStopPlaceholder = "<tour_or_stop_name>"
        static let tourShareString = "Exploring \(tourOrStopPlaceholder) in \(twitterAccount) \(hashtag)"
    }
    
    struct UseDefaults {
        static let tour = "tour"
        static let tours = "tours"
    }
    
    static let defaultTour = "history_of_science_tour_stop"
    
}