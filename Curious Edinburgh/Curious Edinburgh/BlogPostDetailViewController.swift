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
       
        let count = (self.blogPost?.images?.count)!

        if let _ = self.blogPost?.videoLink {
            return (count + 1)
        }
        return count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        
        if let blogPost = self.blogPost{
            
            if (indexPath.item == 0){
                //do all the stuff here for the video
                let videoCell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Table.detailCellVideoReusetIdentifier, forIndexPath: indexPath) as! BlogPostDetailVideoCollectionViewCell
                
                if let videoLink = blogPost.videoLink {
                    videoCell.webView.loadRequest( NSURLRequest(URL: videoLink) )
                    return videoCell
                }
            }
            
            // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Table.detailCellReuseIdentifier, forIndexPath: indexPath) as! BlogPostDetailCollectionViewCell
    
            self.setCellImage(cell, blogPost: blogPost, indexPath: indexPath)
          
            return cell
        }
       
        return cell
    }
    
    func setCellImage(cell: BlogPostDetailCollectionViewCell, blogPost: BlogPost, indexPath:NSIndexPath ) {
        let defaultItemThumbnail = UIImage(named: "DefaultTableVIewThumbnail")
        
        if let images = blogPost.images{
            
//            var image = String()
//     
//            // Adjust index for existence of video
//            if let _ = self.blogPost?.videoLink {
//                image = images[(indexPath.item - 1)]
//            }else{
//                image = images[(indexPath.item)]
//            }

        
            
            
            if let URL = NSURL(string: images[self.adjustedCellIndex(indexPath)]) {
                
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
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        performSegueWithIdentifier(Constants.SegueIDs.showImage, sender: indexPath)

    }
    
    func adjustedCellIndex(indexPath: NSIndexPath) -> Int {
        var index = indexPath.item
        if let _ = self.blogPost?.videoLink {
            index = index - 1
        }
        return index
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller..
        
        if segue.identifier == Constants.SegueIDs.showImage {
            if let imvc = segue.destinationViewController as? ImageViewController{
               
                if let indexPath = collectionView.indexPathsForSelectedItems(){
                    
                    // Adjust index if there is a video
                    var index = indexPath[0].row
                    if let _ = self.blogPost?.videoLink {
                        index = index - 1
                    }
                    let imageUrl = self.blogPost?.images?[self.adjustedCellIndex(indexPath[0])]
                    imvc.imageURL = imageUrl
                }
            }
        }
    }
}