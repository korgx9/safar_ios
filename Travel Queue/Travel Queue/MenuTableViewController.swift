//
//  MenuTableViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 3/27/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    private let apiRequester = APIRequester.sharedInstance
    private let utilities = Utilities()
    private let passwordFieldKey = "passField"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        utilities.setBackgroundImage(tableView)
        utilities.setBackgroundImage(view)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("AccountViewController")
            let navigation = UINavigationController(rootViewController: vc)
            self.presentViewController(navigation, animated: true, completion: nil)
            break
        case 2:
            self.presentViewController(utilities.callToCallcenter(), animated: true, completion: nil)
            break
        case 3:
            let message = NSLocalizedString("Best app to travel in Tajikistan http://safar.tj", comment: "Share text")
            let activityViewController = UIActivityViewController (
                activityItems: [message as NSString], applicationActivities: nil)
            presentViewController(activityViewController,
                                  animated: true,
                                  completion: {})
            break
        case 4:
            self.apiRequester.user = nil
            NSUserDefaults.standardUserDefaults().removeObjectForKey(passwordFieldKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            UITextField.appearance().textColor = UIColor.whiteColor()
            break
        default:
            break
        }
    }
    
    func transitionTabbar(selectedIndex: Int) {
        
        let controllersArray = self.tabBarController!.viewControllers as [UIViewController]?
        let toView = controllersArray![selectedIndex].view
        
        UIView.transitionFromView(
            self.view,
            toView: toView,
            duration: 0.5,
            options: UIViewAnimationOptions.TransitionFlipFromLeft,
            completion: {
                finished in
                if finished {
                    self.tabBarController?.selectedIndex = selectedIndex
                }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
