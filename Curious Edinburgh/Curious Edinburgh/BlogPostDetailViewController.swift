//
//  BlogPostDetailViewController.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 19/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import AlamofireImage

class BlogPostDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var blogPost: BlogPost?
 
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    @IBOutlet weak var videoView: UIWebView!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.whiteColor()
        
        self.titleLabel.title = blogPost?.title
        self.videoView.scrollView.scrollEnabled = false
        self.videoView.scrollView.bounces = false
        let videoId = "fuD3Zco0aXs"
        self.loadYouTube(videoId)
        
        if let content = blogPost?.strippedContent {
            self.textView.text = content
        }
        
        self.textView.layer.masksToBounds = false;
        self.textView.layer.cornerRadius = 1; // if you like rounded corners
        self.textView.layer.shadowOffset = CGSizeMake(-0.3, 0.3)
        self.textView.layer.shadowRadius = 1;
        self.textView.layer.shadowOpacity = 0.2;
        self.textView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.textView.layer.borderWidth = 0.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadYouTube(videoID:String) {
        guard
            let youtubeURL = NSURL(string: "https://www.youtube.com/embed/\(videoID)")
            else { return }
        videoView.loadRequest( NSURLRequest(URL: youtubeURL) )
    }

    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.blogPost?.images?.count ?? 0
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Table.detailCellReuseIdentifier, forIndexPath: indexPath) as! BlogPostDetailCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell

        if let blogPost = self.blogPost{
           self.setCellImage(cell, blogPost: blogPost, indexPath: indexPath)
        }
       
        return cell
    }
    
    func setCellImage(cell: BlogPostDetailCollectionViewCell, blogPost: BlogPost, indexPath:NSIndexPath ) {
        let defaultItemThumbnail = UIImage(named: "DefaultTableVIewThumbnail")
        
        if let images = blogPost.images{
            let image = images[indexPath.item]
            if let URL = NSURL(string: image) {
                
                let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                    size: cell.postThumbnail.frame.size,
                    radius: 5.0
                )
                cell.postThumbnail.af_setImageWithURL(URL,
                                                      placeholderImage: defaultItemThumbnail,
                                                      filter: filter,
                                                      imageTransition: .FlipFromBottom(0.5))
            }
        }
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
