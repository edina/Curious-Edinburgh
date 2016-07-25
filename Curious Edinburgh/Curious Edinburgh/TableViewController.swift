//
//  TableViewController.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 14/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import CoreData
import DATAStack
import SwiftyJSON
import AlamofireImage

class TableViewController: UITableViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var tour: String {
        get {
            if let tour = self.defaults.stringForKey(Constants.UseDefaults.tour){
                return tour
            } else {
                return Constants.defaultTour
            }
        }
    }

    var blogPosts = [BlogPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen for sync completion notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.changeNotification(_:)), name:Constants.Notifications.SyncComplete, object: nil)
        
        // Listen for tour selected notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.changeNotification(_:)), name:Constants.Notifications.TourSelected, object: nil)
        
        self.fetchCurrentObjects()
    }
    
    func tourNumberImage(post: BlogPost) -> UIImage {
        let text = post.tourNumber
        let marker = UIImage(named:Constants.ImageIdentifiers.tourNumber)
        
        // Setup the font specific variables
        let textColor = UIColor.whiteColor()
        let fontSize:CGFloat = 12.0
        let textFont = UIFont.boldSystemFontOfSize(fontSize)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            //        NSStrokeColorAttributeName: UIColor.blackColor(),
            //        NSStrokeWidthAttributeName: 3.0
        ]
        
        if let marker = marker, text = text {
            
            // Create bitmap based graphics context
            UIGraphicsBeginImageContextWithOptions(marker.size, false, 0.0)
            
            //Put the image into a rectangle as large as the original image.
            marker.drawInRect(CGRectMake(0, 0, marker.size.width, marker.size.height))
            
            // Our drawing bounds
            let drawingBounds = CGRectMake(0.0, 0.0, marker.size.width, marker.size.height)
            
            let textSize = text.sizeWithAttributes([NSFontAttributeName:textFont])
            let textRect = CGRectMake(drawingBounds.size.width/2 - textSize.width/2, drawingBounds.size.height/2 - textSize.height/2,
                                      textSize.width, textSize.height)
            
            text.drawInRect(textRect, withAttributes: textFontAttributes)
            
            // Get the image from the graphics context
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
        }
        
        return marker!
    }
    
 
    // MARK: - Update Table
  
    func fetchCurrentObjects() {
        self.blogPosts = curiousEdinburghAPI.fetchBlogPostsFromCoreData(self.tour)
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blogPosts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Table.blogPostIdentifier, forIndexPath: indexPath) as! PostCardCustomCell
      
        let blogPost = self.blogPosts[indexPath.row]
        
        cell.postTitle.text = blogPost.title?.uppercaseString
        
        // Note that strippedContent is temporary until all mainText fields are populated
        if let content = blogPost.mainText ?? blogPost.strippedContent{
            cell.postDescription.text = content.trunc(240)
        }
        
        self.setCellImage(cell, blogPost: blogPost)
        
        cell.tourNumber.image = tourNumberImage(blogPost)
        cell.contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        return cell
    }
 
    func setCellImage(cell: PostCardCustomCell, blogPost: BlogPost) {
        let defaultItemThumbnail = UIImage(named: Constants.ImageIdentifiers.defaultThumbnail)
        
        if let images = blogPost.images{
            let image = images[0]
            if let URL = NSURL(string: image) {
                
                let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                    size: cell.postThumbnail.frame.size,
                    radius: Constants.View.defaultCornerRadius
                )
                cell.postThumbnail.af_setImageWithURL(URL,
                                                      placeholderImage: defaultItemThumbnail,
                                                      filter: filter,
                                                      imageTransition: .FlipFromBottom(0.5))
            }
        }
    }
    
    // MARK: - Notification
    
    func changeNotification(notification: NSNotification) {
        // Sync with API is complete so we can populate map
        self.fetchCurrentObjects()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.SegueIDs.showBlogPostDetail {
            if let destination = segue.destinationViewController as? BlogPostDetailViewController {
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    destination.blogPost = self.blogPosts[blogIndex]
                }
            }
        }
        
    }
    

}