//
//  BlogPostDetailCollectionViewCell.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 25/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit

class BlogPostDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var postThumbnail: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    
    override func layoutSubviews() {
        self.setUpTumbnailImageView()
    }
    
    func setUpTumbnailImageView() {
        postThumbnail.clipsToBounds = true;
        postThumbnail.contentMode = UIViewContentMode.ScaleAspectFit
        postThumbnail.backgroundColor = UIColor.whiteColor()
    }
    
}

