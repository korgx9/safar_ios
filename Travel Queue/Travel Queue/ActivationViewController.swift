//
//  ActivationViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 12/14/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit

class ActivationViewController: UIViewController {
    
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var approveButton: UIButton!
    
    var username:String!
    private let apiRequester = APIRequester.sharedInstance
    private let mainSegueIdentifier = "MainSegueIdentifier"
    private let utilities = Utilities()
    private let OPERATION_SUCCESS = 0
    private let WRONG_CODE_ENTERED = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName : Variables.Colors.NavigationBar.Text]
        self.navigationController?.navigationBar.tintColor = Variables.Colors.NavigationBar.Tint
        utilities.setBackgroundImage(view)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onUserRegistered:",
            name: Variables.Notifications.Activate,
            object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.Activate)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        utilities.addBottomBorderTo(codeField, color: UIColor.whiteColor())
        utilities.textFieldPlaceholderColor(codeField, color: UIColor.whiteColor())
        utilities.addBordersToButtonWithColor(approveButton, color: UIColor.whiteColor(), width: 2.0, cornerRadius: 3.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        
        if identifier == mainSegueIdentifier {
            if codeField.text == "" {
                let alert = Utilities.showOKAlert(NSLocalizedString("Error", comment: "Alert title if error happened"),
                    message: NSLocalizedString("Please, enter code", comment: "Alert text if user didn't entered code in textbox"))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                let code = codeField.text
                utilities.showProgressHud(NSLocalizedString("Activating", comment: "HUD title when activating"), forView: view)
                apiRequester.activate(username, code: code!)
            }
        }
        return false
    }
    
    func onUserRegistered(notification: NSNotification) {
        utilities.hideProgressHud()
        switch notification.object!.integerValue {
        case OPERATION_SUCCESS..<Int.max:
            apiRequester.getUserById(notification.object!.integerValue)
            performSegueWithIdentifier(mainSegueIdentifier, sender: self)
            break
        case WRONG_CODE_ENTERED:
            let alert = Utilities.showOKAlert(NSLocalizedString("Error", comment: "Alert title if user entered wrong code"),
                message: NSLocalizedString("User exists", comment: "Alert text if user entered wrong code"))
            presentViewController(alert, animated: true, completion: nil)
            break
        default:
            print("recieved smth else then known statuses")
            print(notification.object?.integerValue)
            break
        }
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }

}
