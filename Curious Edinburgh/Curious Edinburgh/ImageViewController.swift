//
//  ImageViewController.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 27/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import AlamofireImage
class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL = String?()
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        let defaultItemThumbnail = UIImage(named: "DefaultTableVIewThumbnail")
        if let image = imageURL{
            if let URL = NSURL(string: image) {
                self.imageView.af_setImageWithURL(URL,
                                                  placeholderImage: defaultItemThumbnail,
                                                  filter: nil,
                                                  imageTransition: .None)
                
            }
        }
        
    }
    

    @IBAction func imageTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
