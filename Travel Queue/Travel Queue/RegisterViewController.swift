//
//  RegisterViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 11/15/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var codeField: UITextField!
    
    private let apiRequester = APIRequester.sharedInstance
    private let activationSegueIdentifier = "activationSegue"
    private let utilities = Utilities()
    
    private let USER_ALREADY_EXISTS = -2
    private let MIN_PASSWORD_LENGTH_ERROR = -3
    private let OPERATION_SUCCESS = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName : Variables.Colors.NavigationBar.Text]
        self.navigationController?.navigationBar.tintColor = Variables.Colors.NavigationBar.Tint
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(RegisterViewController.onUserRegistered(_:)),
            name: Variables.Notifications.Regiser,
            object: nil)
        
        utilities.setBackgroundImage(view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        utilities.addBottomBorderTo(nameField, color: UIColor.whiteColor())
        utilities.addBottomBorderTo(surnameField, color: UIColor.whiteColor())
        utilities.addBottomBorderTo(phoneField, color: UIColor.whiteColor())
        utilities.addBottomBorderTo(passwordField, color: UIColor.whiteColor())
        utilities.addBottomBorderTo(codeField, color: UIColor.whiteColor())
        
        utilities.textFieldPlaceholderColor(nameField, color: UIColor.whiteColor())
        utilities.textFieldPlaceholderColor(surnameField, color: UIColor.whiteColor())
        utilities.textFieldPlaceholderColor(phoneField, color: UIColor.whiteColor())
        utilities.textFieldPlaceholderColor(passwordField, color: UIColor.whiteColor())
        utilities.textFieldPlaceholderColor(codeField, color: UIColor.whiteColor())
        
        utilities.addBordersToButtonWithColor(registerButton, color: UIColor.whiteColor(), width: 2.0, cornerRadius: 3.0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.Regiser)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {

        if identifier == activationSegueIdentifier {
            if nameField.text == "" || surnameField.text == "" || phoneField.text == "" || passwordField == "" || codeField.text == "" {
                let alert = Utilities.showOKAlert(NSLocalizedString("Error", comment: "Alert title if error happened"),
                    message: NSLocalizedString("Please, fill all required fields", comment: "Alert text if user didn't filled all data when registering"))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                utilities.showProgressHud(NSLocalizedString("Registering", comment: "Registering title on hud"), forView: self.view)
                apiRequester.register(codeField.text! + phoneField.text!, password: passwordField.text!, name: nameField.text!, surname: surnameField.text!)
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == activationSegueIdentifier) {
            let secondViewController = segue.destinationViewController as! ActivationViewController
            secondViewController.username = codeField.text! + phoneField.text!
        }
    }
    
    func onUserRegistered(notification: NSNotification) {
        utilities.hideProgressHud()
        switch notification.object!.integerValue {
        case OPERATION_SUCCESS..<Int.max:
            print("received \(notification.object?.integerValue)", terminator: "")
            performSegueWithIdentifier(activationSegueIdentifier, sender: self)
            break
        case USER_ALREADY_EXISTS:
            let alert = Utilities.showOKAlert(NSLocalizedString("Error", comment: "Alert title if user already exists"),
                message: NSLocalizedString("User exists", comment: "Alert text if user already exists"))
            presentViewController(alert, animated: true, completion: nil)
            break
        case MIN_PASSWORD_LENGTH_ERROR:
            let alert = Utilities.showOKAlert(NSLocalizedString("Error", comment: "Alert title if password length is too short"),
                message: NSLocalizedString("Your password is too short", comment: "Alert text if password length is too short"))
            presentViewController(alert, animated: true, completion: nil)
            break
        default:
            print("recieved smth else then known statuses", terminator: "")
            print(notification.object?.integerValue, terminator: "")
            break
        }
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
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
