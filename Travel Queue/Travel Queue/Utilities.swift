//
//  Utilities.swift
//  Travel Queue
//
//  Created by Kesh Pola on 10/7/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit
import JGProgressHUD

class Utilities: NSObject {
    private let progressHud = JGProgressHUD()

    static func showOKAlert(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK Alert button text"), style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        
        return alert
    }
    
    static func getUIColorFromHex(stringColor: Int) -> UIColor {
        let r = CGFloat((stringColor & 0xFF0000) >> 16)/255.0
        let g = CGFloat((stringColor & 0xFF00) >> 8)/255.0
        let b = CGFloat((stringColor & 0xFF))/255.0
        return UIColor(red:r, green: g, blue: b, alpha:1.0)
    }
    
    static func callToNumber(number: String) {
        let url = NSURL(string:String(format: "tel://%@", number));
        UIApplication.sharedApplication().openURL(url!)
    }
    
    static func rotateCameraImageToProperOrientation(imageSource : UIImage, maxResolution : CGFloat) -> UIImage {
        
        let imgRef = imageSource.CGImage;
        
        let width = CGFloat(CGImageGetWidth(imgRef));
        let height = CGFloat(CGImageGetHeight(imgRef));
        
        var bounds = CGRectMake(0, 0, width, height)
        
        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        
        var transform = CGAffineTransformIdentity
        let orient = imageSource.imageOrientation
        let imageSize = CGSizeMake(CGFloat(CGImageGetWidth(imgRef)), CGFloat(CGImageGetHeight(imgRef)))
        
        
        switch(imageSource.imageOrientation) {
        case .Up :
            transform = CGAffineTransformIdentity
            
        case .UpMirrored :
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            
        case .Down :
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI));
            
        case .DownMirrored :
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            
        case .Left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);
            
        case .LeftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);
            
        case .Right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);
            
        case .RightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        if orient == .Right || orient == .Left {
            CGContextScaleCTM(context, -scaleRatio, scaleRatio);
            CGContextTranslateCTM(context, -height, 0);
        } else {
            CGContextScaleCTM(context, scaleRatio, -scaleRatio);
            CGContextTranslateCTM(context, 0, -height);
        }
        
        CGContextConcatCTM(context, transform);
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return imageCopy;
    }
    
    func showProgressHud (title: String, forView: UIView) {
        progressHud.textLabel.text = title
        progressHud.showInView(forView, animated: true)
    }
    
    func showProgressHudWithTick (forView: UIView) {
        progressHud.textLabel.text = NSLocalizedString("COMPLETE", comment: "Complete hud")
        progressHud.showInView(forView)
        //var tickImage = UIImage(named: "ggl")
        //var view = UIImageView(image: tickImage)
        //progressHud.contentView.addSubview(view)
        progressHud.dismissAfterDelay(1)
    }
    
    func hideProgressHud () {
        progressHud.dismissAnimated(true)
    }
    
    func addBottomBorderTo(textField: UITextField, color: UIColor) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, textField.frame.size.height - 1, textField.frame.size.width, 1.0)
        bottomBorder.backgroundColor = color.CGColor
        textField.layer.addSublayer(bottomBorder)
    }
    
    func addBordersToButtonWithColor(button: UIButton, color: UIColor, width: CGFloat, cornerRadius: CGFloat) {
        button.layer.borderColor = color.CGColor
        button.layer.borderWidth = width
        button.layer.cornerRadius = cornerRadius
    }
    
    func textFieldPlaceholderColor(textField: UITextField, color: UIColor) {
       if #available(iOS 9.0, *) {
           UILabel.appearanceWhenContainedInInstancesOfClasses([UITextField.self]).textColor = color
       }
       else {
           // Fallback on earlier versions
       }
    }

}
