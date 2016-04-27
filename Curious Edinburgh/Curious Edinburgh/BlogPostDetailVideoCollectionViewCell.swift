//
//  BlogPostDetailVideoCollectionViewCell.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 26/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit

class BlogPostDetailVideoCollectionViewCell: UICollectionViewCell, UIWebViewDelegate {
    
    
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var defaultImage: UIImageView!
    
    override func layoutSubviews() {
        self.webView.delegate = self
        
        // Ensure the webview has rounded corners
        webView.layer.cornerRadius = Constants.View.defaultCornerRadius;
        webView.layer.masksToBounds = true;
    }
    
    
    // MARK: - UIWebViewDelegate protocol
    func webViewDidFinishLoad(webView: UIWebView) {
        
        // Perform flip animation between default image and webview with video
        UIView.transitionFromView(self.defaultImage, toView: webView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromBottom, completion: nil)
    }
}
