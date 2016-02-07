//
//  Utilities.swift
//  Travel Queue
//
//  Created by Kesh Pola on 10/7/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit

class Utilities: NSObject {
//    static let progressHud = JGProgressHUD()

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
    
//    static func showProgressHud (title: String, forView: UIView) {
//        progressHud.textLabel.text = title
//        progressHud.showInView(forView, animated: true)
//    }
//    
//    func showProgressHudWithTick (forView: UIView) {
//        progressHud.textLabel.text = NSLocalizedString("COMPLETE", comment: "Complete hud")
//        progressHud.showInView(forView)
//        //var tickImage = UIImage(named: "ggl")
//        //var view = UIImageView(image: tickImage)
//        //progressHud.contentView.addSubview(view)
//        progressHud.dismissAfterDelay(1)
//    }
//    
//    static func hideProgressHud () {
//        progressHud.dismissAnimated(true)
//    }

}
