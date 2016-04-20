//
//  BlogPostDetailViewController.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 19/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit

class BlogPostDetailViewController: UIViewController, UIWebViewDelegate {

    
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
            
            let styleElement = "<style>body { font-family: HelveticaNeue; padding: 0; margin: 0; } p { margin: 1em; } img { width: 40%; height: auto; float: left; padding: 1em 1em 1em 0; }</style>"
            let headElement = "<head><title>\(blogPost?.title!)</title>\(styleElement)</head>"
            
            let htmlElement = "<html>\(headElement)<body>\(content)</body></html>"
            
            self.webView.loadHTMLString(htmlElement, baseURL: nil)
        }
        
        webViewDidFinishLoad(self.webView)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadYoutube(videoID videoID:String) {
        guard
            let youtubeURL = NSURL(string: "https://www.youtube.com/embed/\(videoID)")
            else { return }
        videoView.loadRequest( NSURLRequest(URL: youtubeURL) )
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
//        webView.scrollView.scrollEnabled = false;
//        webView.scrollView.bounces = false
        
        var frame = webView.frame;
        
        frame.size.height = 1;        // Set the height to a small one.
        
        webView.frame = frame;       // Set webView's Frame, forcing the Layout of its embedded scrollView with current Frame's constraints (Width set above).
        
        frame.size.height = webView.scrollView.contentSize.height;
        webView.frame = frame;
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
