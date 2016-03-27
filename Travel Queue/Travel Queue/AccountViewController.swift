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

    private let apiRequester = APIRequester.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        accountNumberLabel.text = apiRequester.user?.phonenumber
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
