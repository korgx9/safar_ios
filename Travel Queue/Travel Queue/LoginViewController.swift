//
//  LoginViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 10/7/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit
import JGProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var safarLogo: UILabel!
    @IBOutlet weak var safarLogoImage: UIImageView!
    @IBOutlet weak var safarLogoImageBackground: UITextField!
    
    @IBOutlet weak var logoConstraint: NSLayoutConstraint!
    private let apiRequester = APIRequester.sharedInstance
    private let utilities = Utilities()
    private let mainPageSegue = "MainPageSegue"
    private let registerPageSegue = "RegisterSegue"
    private var isAnimated = false
    
    private let NO_SUCH_USER = -2
    private let WRONG_USER_OR_PWD = -1
    private let LOGIN_SUCCESS = 0
    
    private let codeFieldKey = "codeField"
    private let phoneFieldKey = "phoneField"
    private let passwordFieldKey = "passField"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        codeField.delegate = self
        loginField.delegate = self
        passwordField.delegate = self
        loginButton.layer.cornerRadius = 5.0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        codeField.alpha = 0
        loginField.alpha = 0
        passwordField.alpha = 0
        
        utilities.setBackgroundImage(self.view)
        
        if let codeSaved = NSUserDefaults.standardUserDefaults().stringForKey(codeFieldKey) {
            codeField.text = codeSaved
            if let loginSaved = NSUserDefaults.standardUserDefaults().stringForKey(phoneFieldKey) {
                loginField.text = loginSaved
                if let password = NSUserDefaults.standardUserDefaults().stringForKey(passwordFieldKey) {
                    if codeField.text != "" && loginField.text != "" && password != "" {
                        apiRequester.login(codeField.text! + loginField.text!, password: password)
                    }
                }
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onUserLoggedIn:",
            name: Variables.Notifications.Login,
            object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.Login)
    }
    
    func animateLogo() {
        if !isAnimated {
            logoConstraint.constant = logoConstraint.constant - 70.0
            
            UIView.animateWithDuration(1.5, delay:0, options: .CurveEaseInOut, animations:{ Void in
                self.view.layoutIfNeeded()
                self.safarLogo.alpha = 0
                self.safarLogoImageBackground.alpha = 0.3
                },
                completion: {finished -> Void in
                    UIView.animateWithDuration(0.5, animations:{
                        self.codeField.alpha = 1.0
                        self.loginField.alpha = 1.0
                        self.passwordField.alpha = 1.0
                })
            })
            isAnimated = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        utilities.addBottomBorderTo(loginField, color: UIColor.whiteColor())
        utilities.addBottomBorderTo(passwordField, color: UIColor.whiteColor())
        utilities.addBottomBorderTo(codeField, color: UIColor.whiteColor())
        utilities.addBordersToButtonWithColor(loginButton, color: UIColor.whiteColor(), width: 2.0, cornerRadius: 3.0)
        utilities.textFieldPlaceholderColor(loginField, color: UIColor.whiteColor())
        utilities.textFieldPlaceholderColor(passwordField, color: UIColor.whiteColor())
        utilities.textFieldPlaceholderColor(codeField, color: UIColor.whiteColor())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        animateLogo()
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
                utilities.showProgressHud(NSLocalizedString("Login", comment: "Registering title on hud"), forView: view)
                apiRequester.login(codeField.text! + loginField.text!, password: passwordField.text!)
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
        utilities.hideProgressHud()
        switch notification.object!.integerValue {
        case LOGIN_SUCCESS..<Int.max:
            NSUserDefaults.standardUserDefaults().setObject(self.codeField.text, forKey: self.codeFieldKey)
            NSUserDefaults.standardUserDefaults().setObject(self.loginField.text, forKey: self.phoneFieldKey)

            if self.passwordField.text != nil && self.passwordField.text != "" {
                NSUserDefaults.standardUserDefaults().setObject(self.passwordField.text, forKey: self.passwordFieldKey)
            }
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
