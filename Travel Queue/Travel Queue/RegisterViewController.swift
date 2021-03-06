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
    
    private let apiRequester = APIRequester.sharedInstance
    private let activationSegueIdentifier = "activationSegue"
    
    private let USER_ALREADY_EXISTS = -2
    private let MIN_PASSWORD_LENGTH_ERROR = -3
    private let OPERATION_SUCCESS = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onUserRegistered:",
            name: Variables.Notifications.Regiser,
            object: nil)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
            if nameField.text == "" || surnameField.text == "" || phoneField.text == "" || passwordField == "" {
                let alert = Utilities.showOKAlert(NSLocalizedString("Error", comment: "Alert title if error happened"),
                    message: NSLocalizedString("Please, fill all required fields", comment: "Alert text if user didn't filled all data when registering"))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
//                Utilities.showProgressHud(NSLocalizedString("Registering", comment: "Registering title on hud"), forView: self.view)
                apiRequester.register(phoneField.text!, password: passwordField.text!, name: nameField.text!, surname: surnameField.text!)
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == activationSegueIdentifier) {
            let secondViewController = segue.destinationViewController as! ActivationViewController
            secondViewController.username = phoneField.text!
        }
    }
    
    func onUserRegistered(notification: NSNotification) {
        switch notification.object!.integerValue {
        case OPERATION_SUCCESS..<Int.max:
            print("received \(notification.object?.integerValue)")
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
            print("recieved smth else then known statuses")
            print(notification.object?.integerValue)
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
