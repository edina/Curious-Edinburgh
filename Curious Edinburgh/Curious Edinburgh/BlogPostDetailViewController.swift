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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var videoView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = blogPost?.title
        
        if let content = blogPost?.contentValue {
            let videoId = "fuD3Zco0aXs"
            let youtubeElement = "<iframe width=\"100%\" height=\"100px\" src=\"https://www.youtube.com/embed/\(videoId)\" frameborder=\"0\" allowfullscreen></iframe>"
            let content = "\(youtubeElement)\(content)"
            
            let styleElement = "<style>body { font-family: HelveticaNeue; padding: 0; margin: 0; } p { margin: 1em; } img { width: 40%; height: auto; float: left; padding: 0 1em 0.25em 0; }</style>"
            let headElement = "<head><title>\(blogPost?.title!)</title>\(styleElement)</head>"
            
            let htmlElement = "<html>\(headElement)<body>\(content)</body></html>"
            
            self.webView.loadHTMLString(htmlElement, baseURL: nil)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
