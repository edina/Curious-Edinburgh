//: Playground - noun: a place where people can play

import UIKit

func addTextToImage(text: NSString, inImage: UIImage) -> UIImage{
    
    // Setup the font specific variables
    let textColor = UIColor.whiteColor()
    let fontSize:CGFloat = 11.0
    let textFont = UIFont.boldSystemFontOfSize(fontSize)
    
    //Setups up the font attributes that will be later used to dictate how the text should be drawn
    let textFontAttributes = [
        NSFontAttributeName: textFont,
        NSForegroundColorAttributeName: textColor,
//        NSStrokeColorAttributeName: UIColor.blackColor(),
//        NSStrokeWidthAttributeName: 3.0
        ]
    
    // Create bitmap based graphics context
    UIGraphicsBeginImageContextWithOptions(inImage.size, false, 0.0)
    
    //Put the image into a rectangle as large as the original image.
    inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
    
    // Our drawing bounds
    let drawingBounds = CGRectMake(0.0, 0.0, inImage.size.width, inImage.size.height/3)
    
    let textSize = text.sizeWithAttributes([NSFontAttributeName:textFont])
    let textRect = CGRectMake(drawingBounds.size.width/2 - textSize.width/2, drawingBounds.size.height/2 - textSize.height/2,
                              textSize.width, textSize.height)
    
    text.drawInRect(textRect, withAttributes: textFontAttributes)
    
    // Get the image from the graphics context
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
    
}

if let circleImage = UIImage(named: "CuriousEdinburghMarker.png"){
//if let circleImage = UIImage(named: "CustomMapMarker.png"){
    let customImage1 = addTextToImage("1", inImage: circleImage)
    let customImage2 = addTextToImage("2", inImage: circleImage)
    let customImage3 = addTextToImage("3", inImage: circleImage)
    let customImage4 = addTextToImage("4", inImage: circleImage)
    let customImage5 = addTextToImage("5", inImage: circleImage)
    let customImage6 = addTextToImage("6", inImage: circleImage)
    let customImage7 = addTextToImage("7", inImage: circleImage)
    let customImage8 = addTextToImage("8", inImage: circleImage)
    let customImage9 = addTextToImage("9", inImage: circleImage)
    let customImage10 = addTextToImage("10", inImage: circleImage)
    let customImage11 = addTextToImage("11", inImage: circleImage)
    let customImage22 = addTextToImage("22", inImage: circleImage)
    let customImage33 = addTextToImage("33", inImage: circleImage)
    let customImage44 = addTextToImage("44", inImage: circleImage)
    let customImage55 = addTextToImage("55", inImage: circleImage)
    let customImage66 = addTextToImage("66", inImage: circleImage)
    let customImage77 = addTextToImage("77", inImage: circleImage)
    let customImage88 = addTextToImage("88", inImage: circleImage)
    let customImage99 = addTextToImage("99", inImage: circleImage)
}
