//
//  AccountViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 3/27/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    private let apiRequester = APIRequester.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        accountNumberLabel.text = apiRequester.user?.phonenumber
        usernameLabel.text = (apiRequester.user?.name)! + " " + (apiRequester.user?.surname)!
//        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.navigationBarHidden = false
        
        let closeButon = UIButton()
        closeButon.frame = CGRectMake(0, 0, 70, 30)
        closeButon.titleLabel!.font =  UIFont(name: "System", size: 15)
        closeButon.setTitle(NSLocalizedString("Close", comment: "Close button on comments view in navigation bar"), forState: .Normal)
        closeButon.addTarget(self, action: #selector(AccountViewController.dismissSelf), forControlEvents: .TouchUpInside)
        
        let closeBarButton = UIBarButtonItem()
        closeBarButton.customView = closeButon
        self.navigationItem.leftBarButtonItem = closeBarButton
        
        self.navigationController?.navigationBar.barTintColor = Utilities.getUIColorFromHex(0x007AFF)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    func dismissSelf() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
