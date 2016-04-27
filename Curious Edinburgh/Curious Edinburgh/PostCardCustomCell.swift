//
//  PostCardCustomCell.swift
//  Curious Edinburgh
//
//  Created by Ian Fieldhouse on 22/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//
import UIKit

class PostCardCustomCell: UITableViewCell {
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postThumbnail: UIImageView!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tourNumber: UIImageView!
    
    override func layoutSubviews() {
        self.setUpCardView()
        self.setUpTumbnailImageView()
    }
    
    func setUpCardView() {
        self.cardView.alpha = 1
        
        cardView.layer.masksToBounds = false;
        cardView.layer.cornerRadius = 1 // if you like rounded corners
        cardView.layer.shadowOffset = CGSizeMake(-0.3, 0.3)
        cardView.layer.shadowRadius = 1
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        cardView.layer.borderWidth = 0.5
    }
    
    
    func setUpTumbnailImageView() {
        // postThumbnail.layer.cornerRadius = postThumbnail.frame.size.width/2 // round image
        postThumbnail.layer.cornerRadius = 5
        postThumbnail.clipsToBounds = true;
        postThumbnail.contentMode = UIViewContentMode.ScaleAspectFit
        postThumbnail.backgroundColor = UIColor.whiteColor()
    }

}