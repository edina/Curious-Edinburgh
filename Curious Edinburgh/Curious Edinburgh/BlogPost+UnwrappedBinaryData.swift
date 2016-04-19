//
//  BlogPost+UnwrappedBinaryData.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 19/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

extension BlogPost {
    
    var titleAsString: String {
        get {
            if let title = NSKeyedUnarchiver.unarchiveObjectWithData(self.title!){
                let titleJson = JSON(title)
                return String(htmlEncodedString :titleJson["rendered"].stringValue)
            }
            return "";
        }
    }
    
    
    var location: CLLocationCoordinate2D? {
        get {
            var location: CLLocationCoordinate2D?
            
            if let customFields = NSKeyedUnarchiver.unarchiveObjectWithData(self.customFields!){
                let customFieldsJson = JSON(customFields)
                
                if let lat = customFieldsJson["latitude"].string, lon = customFieldsJson["longitude"].string {
                    location = CLLocationCoordinate2D(
                        latitude: Double(lat)!,
                        longitude: Double(lon)!
                    )
                }
            }
            
            return location
        }
    }

}


extension String {
    init(htmlEncodedString: String) {
        let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        
        var attributedString:NSAttributedString?
        
        do{
            attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
        }catch{
            print(error)
        }
        
        self.init(attributedString!.string)
    }
}