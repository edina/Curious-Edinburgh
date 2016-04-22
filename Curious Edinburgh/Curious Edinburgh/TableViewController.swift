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

class TableViewController: UITableViewController {

    var blogPosts = [BlogPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen for sync completion notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.changeNotification(_:)), name:Constants.Notifications.SyncComplete, object: nil)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(TableViewController.fetchCurrentObjects), forControlEvents: .ValueChanged)
        
        self.fetchCurrentObjects()
    }
    
 
    // MARK: - Update Table
  
    func fetchCurrentObjects() {
        self.blogPosts = curiousEdinburghAPI.fetchBlogPostsFromCoreData()
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
        if let content = blogPost.strippedContent {
            cell.postDescription.text = content.trunc(100)
        }
        let defaultItemThumbnail = UIImage(named: "DefaultAnnotationThumbnail")
        
        let imageView = UIImageView(image: defaultItemThumbnail)
        if let images = blogPost.images{
            let defaultImage = images[0]
            let URL = NSURL(string: defaultImage)!
            imageView.af_setImageWithURL(URL, placeholderImage: defaultItemThumbnail)
        }
        cell.postThumbnail.image = imageView.image
        
        return cell
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