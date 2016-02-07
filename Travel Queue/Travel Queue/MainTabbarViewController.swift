//
//  MainTabbarViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 12/17/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        self.tabBar.barTintColor = Variables.Colors.TabBar.Background
        self.tabBar.tintColor = Variables.Colors.TabBar.Tint
        self.tabBar.translucent = false
        
        // Set status bar light
        UIApplication.sharedApplication().statusBarStyle = .Default
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
