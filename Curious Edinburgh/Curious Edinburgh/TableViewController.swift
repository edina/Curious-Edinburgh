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

    var blogPosts = [NSManagedObject]()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(TableViewController.fetchNewData), forControlEvents: .ValueChanged)
        
        self.fetchCurrentObjects()
        self.fetchNewData()

    }

 
    // MARK: - Update Table
    func fetchNewData() {
        curiousEdinburghAPI.blogPosts {
            self.refreshControl?.endRefreshing()
        }
    }


    func fetchCurrentObjects() {
        let request = NSFetchRequest(entityName: "BlogPost")
        
        self.blogPosts = (try! dataStack.mainContext.executeFetchRequest(request)) as! [NSManagedObject]
        self.tableView.reloadData()
    }
    
    
    
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blogPosts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Table.blogPostIdentifier, forIndexPath: indexPath)
      
        if let blogPost = self.blogPosts[indexPath.row] as? BlogPost {
            
            cell.textLabel?.text = blogPost.titleAsString
              
            cell.detailTextLabel?.text = String(blogPost.link!)
            
        }
     
        
        return cell
    }
 

    
    @IBAction func unwindToTableViewController(segue:UIStoryboardSegue) {
        if(segue.sourceViewController .isKindOfClass(BlogPostDetailViewController)){
            // Back at tableView
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.SegueIDs.showBlogPostDetail {
            if let destination = segue.destinationViewController as? BlogPostDetailViewController {
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    destination.blogPost = self.blogPosts[blogIndex] as? BlogPost
                }
            }
        }
        
    }
    

}