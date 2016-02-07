//
//  LoginViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 10/7/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    private let apiRequester = APIRequester.sharedInstance
    private let mainPageSegue = "MainPageSegue"
    private let registerPageSegue = "RegisterSegue"
    
    private let NO_SUCH_USER = -2
    private let WRONG_USER_OR_PWD = -1
    private let LOGIN_SUCCESS = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginField.delegate = self
        passwordField.delegate = self
        loginButton.layer.cornerRadius = 5.0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onUserLoggedIn:",
            name: Variables.Notifications.Login,
            object: nil)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.Login)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        
        if identifier == mainPageSegue {
            if loginField.text == "" || passwordField == "" {
                let alert = Utilities.showOKAlert(NSLocalizedString("Error", comment: "Alert title if error happened"),
                    message: NSLocalizedString("Please, fill all required fields", comment: "Alert text if user didn't filled all data when registering"))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
//                Utilities.showProgressHud(NSLocalizedString("Registering", comment: "Registering title on hud"), forView: self.view)
                apiRequester.login(loginField.text!, password: passwordField.text!)
            }
        }
        if identifier == registerPageSegue {
            return true
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == mainPageSegue) {
//            let secondViewController = segue.destinationViewController as! ActivationViewController
//            secondViewController.username = loginField.text!
        }
    }
    
    func onUserLoggedIn(notification: NSNotification) {
        switch notification.object!.integerValue {
        case LOGIN_SUCCESS..<Int.max:
            apiRequester.getUserById(notification.object!.integerValue)
            performSegueWithIdentifier(mainPageSegue, sender: self)
            break
        case NO_SUCH_USER:
            let alert = Utilities.showOKAlert(NSLocalizedString("Error", comment: "Alert title if user doesn't exists on login"),
                message: NSLocalizedString("User doesn't exists", comment: "Alert text if user deosnt't exists on login"))
            presentViewController(alert, animated: true, completion: nil)
            break
        case WRONG_USER_OR_PWD:
            let alert = Utilities.showOKAlert(NSLocalizedString("Error", comment: "Alert title if wrong password or username on login"),
                message: NSLocalizedString("Wrong user or password", comment: "Alert text if wrong password or username on login"))
            presentViewController(alert, animated: true, completion: nil)
            break
        case -3..<(-Int.max):
            //ACTIVATE
            break
        default:
            print("recieved smth else then known statuses")
            print(notification.object?.integerValue)
            break
        }
    }
}
