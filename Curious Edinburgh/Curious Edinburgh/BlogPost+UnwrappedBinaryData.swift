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
import Kanna

extension BlogPost: MKAnnotation {
    
    var title: String? {
        get {
            var title : String?
            if let rawTitle = self.titleJsonData{
                if let titleUnwrapped = NSKeyedUnarchiver.unarchiveObjectWithData(rawTitle){
                    let titleJson = JSON(titleUnwrapped)
                    title = String(htmlEncodedString :titleJson["rendered"].stringValue)
                }
            }
            return title;
        }
    }

    var contentValue: String? {
        get {
            var content : String?
            if let rawContent = self.content {
                if let unwrappedContent = NSKeyedUnarchiver.unarchiveObjectWithData(rawContent){
                    let contentJSON = JSON(unwrappedContent)
                    content = contentJSON["rendered"].string
                }
            }
            return content
        }
    }
    
    var images: [String]? {
        get {
            var images = [String]?()
            if let content = self.contentValue {
                
                /*let regex = try! NSRegularExpression(pattern: "<.*?>", options: [.CaseInsensitive])
                
                let range = NSMakeRange(0, content.characters.count)
                let htmlLessString :String = regex.stringByReplacingMatchesInString(content, options: [],
                                                                                    range:range ,
                                                                                    withTemplate: "")
                
                print(htmlLessString)
                */
     
                // Extract images from text and add to array
                if let doc = Kanna.HTML(html: content, encoding: NSUTF8StringEncoding) {
                    for link in doc.css("img") {
                        if let source  = link["src"]{
                            if (images?.append(source)) == nil {
                                images = [source]
                            }
                        }
                    }
                }
            }
            return images
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            var coordinate = kCLLocationCoordinate2DInvalid
            
            if let customFields = NSKeyedUnarchiver.unarchiveObjectWithData(self.customFields!){
                let customFieldsJson = JSON(customFields)
                
                if let lat = customFieldsJson["latitude"].string, lon = customFieldsJson["longitude"].string {
                    coordinate = CLLocationCoordinate2D(
                        latitude: Double(lat)!,
                        longitude: Double(lon)!
                    )
                }
            }
            return coordinate
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