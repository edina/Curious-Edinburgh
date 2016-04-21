//
//  BlogPostDetailViewController.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 19/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit

class BlogPostDetailViewController: UIViewController {

    
    var blogPost: BlogPost?
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    @IBOutlet weak var videoView: UIWebView!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.title = blogPost?.title
        self.videoView.scrollView.scrollEnabled = false
        self.videoView.scrollView.bounces = false
        let videoId = "fuD3Zco0aXs"
        self.loadYouTube(videoId)
        
        if let content = blogPost?.strippedContent {
            let content = String(htmlEncodedString : content.stripHTML())
            self.textView.text = content
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
