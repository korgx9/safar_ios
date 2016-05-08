
//
//  CreateOrderPassengerViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 12/20/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit

class ClientSearchForVehicleViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var fromCityTextField: UITextField!
    @IBOutlet weak var toCityTextField: UITextField!
    @IBOutlet weak var dateOfDepartureField: UITextField!
    @IBOutlet weak var countOfPassengersStepper: UIStepper!
    @IBOutlet weak var passengersCountField: UITextField!
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var placeOrderButton: UIButton!

    private let apiRequester = APIRequester.sharedInstance
    private let segueIdentifierDriversList = "OnSearchResultSegue"
    
    private var activeTextField = UITextField()
    private let utilities = Utilities()
    private var customPickerView: UIPickerView?
    private var fromCity = ""
    private var toCity = ""
    
    var isUserEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fromCityTextField.delegate = self
        toCityTextField.delegate = self
        dateOfDepartureField.delegate = self
        
        placeOrderButton.layer.cornerRadius = 3.0
        backgroundLabel.layer.cornerRadius = 5.0
        backgroundLabel.layer.masksToBounds = true
        
        passengersCountField.text = "1"
        placeOrderButton.hidden = isUserEditing
        
        let textColor = UIColor.darkGrayColor()
        fromCityTextField.textColor = textColor
        toCityTextField.textColor = textColor
        dateOfDepartureField.textColor = textColor
        passengersCountField.textColor = textColor
        
        registerForKeyboardNotifications()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ClientSearchForVehicleViewController.onUserPostedOrder(_:)),
            name: Variables.Notifications.PostOrderClient,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ClientSearchForVehicleViewController.onSearchDataReceived(_:)),
            name: Variables.Notifications.SearchDataReceived,
            object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.PostOrderClient)
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.SearchDataReceived)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func passengersCountStepperValueChanged(sender: UIStepper) {
        passengersCountField.text = Int(sender.value).description
    }
    
    //MARK: Textfield delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        if textField == fromCityTextField || textField == toCityTextField {
            customPickerView = UIPickerView()
            customPickerView!.delegate = self
            customPickerView!.dataSource = self
            textField.inputView = customPickerView
        }
        else if textField == dateOfDepartureField {
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.Date
            
//            let oneDay: NSTimeInterval = 60 * 60 * 24;
//            let twoDaysFromNow = NSDate(timeIntervalSinceNow: oneDay * 2)
            datePickerView.minimumDate = NSDate()
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(ClientSearchForVehicleViewController.datePickerAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        }
        
        let customToolBar = utilities.getToolBar()
        customToolBar.targetForAction(#selector(ClientSearchForVehicleViewController.donePicker(_:)), withSender: self)
        textField.inputAccessoryView = customToolBar
    }

    //MARK: PickerView delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return apiRequester.cities!.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NSLocalizedString(apiRequester.cities![row].name, comment: "")
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeTextField.text = NSLocalizedString(apiRequester.cities![row].name, comment: "")
    }
    
    func datePickerAction(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.stringFromDate(sender.date)
        self.dateOfDepartureField.text = strDate
    }
    
    @IBAction func placeOrderButtonTapped(sender: UIButton) {
        
        if fromCityTextField.text == "" ||
        toCityTextField.text == "" || dateOfDepartureField.text == "" {
                let alert = Utilities.showOKAlert(NSLocalizedString("Error", comment: "Alert title if error happened"),
                    message: NSLocalizedString("Please, fill all required fields", comment: "Alert text if user didn't filled all data when creates order"))
                self.presentViewController(alert, animated: true, completion: nil)
        }
        else if checkSameCity() {
            
        }
        else {
            makeTrip()
        }
    }
    
    
    @IBAction func cancelOrderButtonTapped(sender: UIButton) {
        
    }
    
    func onUserPostedOrder(notification: NSNotification) {
        hideProgressHud()
        let alert = Utilities.showOKAlert(NSLocalizedString("Success", comment: "Alert title if success"),
            message: NSLocalizedString("Your order successfully created", comment: "Alert text if client order successfully created"))
        self.presentViewController(alert, animated: true, completion: nil)
        refreshOrderForm()
    }
    
    func donePicker(sender: AnyObject) {
        view.endEditing(true);
        
        if let selectedRow = customPickerView?.selectedRowInComponent(0) {
            switch activeTextField {
            case fromCityTextField:
                fromCity = apiRequester.cities![selectedRow].name
                fromCityTextField.text = NSLocalizedString(apiRequester.cities![selectedRow].name, comment: "City name in textField")
                checkSameCity()
                break
            case toCityTextField:
                toCity = apiRequester.cities![selectedRow].name
                toCityTextField.text = NSLocalizedString(apiRequester.cities![selectedRow].name, comment: "City name in textField")
                checkSameCity()
                break
            case dateOfDepartureField:
                datePickerAction(activeTextField.inputView as! UIDatePicker)
                break
            default:
                break
            }
        }
    }
    
    func refreshOrderForm() {
        fromCityTextField.text = nil
        toCityTextField.text = nil
        dateOfDepartureField.text = nil
        passengersCountField.text = nil
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ClientSearchForVehicleViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ClientSearchForVehicleViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardHeight = Float(keyboardSize.height)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let keyboardY = Float(screenSize.height) - keyboardHeight
        let heightOfContainerFrame: CGFloat = 70.0
        let textboxY = Float(activeTextField.frame.origin.y + activeTextField.frame.size.height + heightOfContainerFrame)
    
        if (textboxY > keyboardY) {
            let newVerticalPosition = CGFloat(keyboardY - textboxY);
            Utilities.moveFrameOfViewToVerticalPositionWithDuration(view, position: newVerticalPosition, duration: 0.3)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        Utilities.moveFrameOfViewToVerticalPositionWithDuration(self.view, position: 0, duration: 0.3)
    }
    
    func makeTrip() {
        utilities.showProgressHud(NSLocalizedString("Request", comment: "HUD on creating passenger order"), forView: self.view)
        self.apiRequester.getVehiclesBy(
            self.fromCity,
            destination: self.toCity,
            duedate: self.dateOfDepartureField.text!,
            passCount: self.passengersCountField.text!
        )
    }
    
    func checkSameCity() -> Bool {
        if toCity == fromCity {
            let alert = Utilities.showOKAlert(NSLocalizedString("Error", comment: "Alert title if error happened"),
                message: NSLocalizedString("Departure address and Destination address should not be the same", comment: "Alert text if user choose the same cities"))
            self.presentViewController(alert, animated: true, completion: nil)
            if self.activeTextField == self.toCityTextField {
                self.toCity = ""
            }
            else {
                self.fromCity = ""
            }
            self.activeTextField.text = nil
            activeTextField.text = nil
            return true
        }
        
        return false
    }
    
    func checkRareRoute(isMakeOrderButtonTapped: Bool) -> Bool {
        if (fromCity != "" && fromCity != "Душанбе" && toCity != "" && toCity != "Душанбе") {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert title when user choose rare route"),
                message: NSLocalizedString("There is a few trips in a month for this route. Do you really want to continue" + "?", comment: "Warning message in alert when user choose rare route"), preferredStyle: .Alert)
            
            let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: "Alert action Yes"), style: .Default, handler: { Void in
                if isMakeOrderButtonTapped {
                    self.makeTrip()
                }
                
            })
            
            let noAction = UIAlertAction(title: NSLocalizedString("No", comment: "Alert action Yes"), style: .Cancel, handler: { Void in
                if isMakeOrderButtonTapped {
                    self.fromCityTextField.text = nil
                    self.toCityTextField.text = nil
                    self.fromCity = ""
                    self.toCity = ""
                }
                else {
                    if self.activeTextField == self.toCityTextField {
                        self.toCity = ""
                    }
                    else {
                        self.fromCity = ""
                    }
                    self.activeTextField.text = nil
                    self.activeTextField.text = nil
                }
            })
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
            return true
        }
        
        return false
    }
    
    func onSearchDataReceived(notification: NSNotification) {
        hideProgressHud()
        let driversList = notification.object as! [DriverQueue]
        
        if driversList.count > 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("DriversListTableViewController") as! DriversListTableViewController
            vc.driverQueueList = driversList
            vc.bookedSeatsCount = Int(passengersCountField.text!)!
            let navController = UINavigationController(rootViewController: vc)
            self.presentViewController(navController, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert title when no result on search"), message: NSLocalizedString("There is no vehicle yet", comment: "Zero search result"), preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "ALert ok button if search result 0"), style: .Default, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
