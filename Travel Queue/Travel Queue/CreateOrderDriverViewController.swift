//
//  CreateOrderDriverViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 12/21/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit

class CreateOrderDriverViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var fromCityTextField: UITextField!
    @IBOutlet weak var toCityTextField: UITextField!
    @IBOutlet weak var dateOfDepartureField: UITextField!
    @IBOutlet weak var countOfPassengersStepper: UIStepper!
    @IBOutlet weak var passengersCountField: UITextField!
    @IBOutlet weak var vehicleModelField: UITextField!
    @IBOutlet weak var vehiclePhotoUploadButton: UIButton!
    @IBOutlet weak var tripPriceField: UITextField!
    @IBOutlet weak var tripDepartureTimeField: UITextField!

    @IBOutlet weak var placeOrderButton: UIButton!
    
    private var apiRequester = APIRequester.sharedInstance
    private var activeTextField = UITextField()
    private let OPERATION_FAILED = -1
    private let OPERATION_SUCCESS = 0
    private let NO_ENOUGH_BALANCE = -2
    private let DATE_BEFORE_TODAY = -3

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        fromCityTextField.delegate = self
        toCityTextField.delegate = self
        dateOfDepartureField.delegate = self
        vehicleModelField.delegate = self
        tripPriceField.delegate = self
        tripDepartureTimeField.delegate = self
        
        placeOrderButton.layer.cornerRadius = 3.0
        
        passengersCountField.text = "1"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onDriverPostedOrder:",
            name: Variables.Notifications.PostOrderDriver,
            object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.PostOrderDriver)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func passengersCountStepperValueChanged(sender: UIStepper) {
        passengersCountField.text = Int(sender.value).description
    }
    
    //MARK: Textfield delegates
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeTextField = textField
        if textField == fromCityTextField || textField == toCityTextField {
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            textField.inputView = pickerView
        }
        else if textField == dateOfDepartureField {
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.Date
            datePickerView.minimumDate = NSDate()
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: Selector("datePickerAction:"), forControlEvents: UIControlEvents.ValueChanged)
        }
        
        return true
    }
    
    //MARK: PickerView delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Variables.cities.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Variables.cities[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeTextField.text = Variables.cities[row]
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
        else if fromCityTextField.text == toCityTextField.text {
            let alert = Utilities.showOKAlert(NSLocalizedString("Error", comment: "Alert title if error happened"),
                message: NSLocalizedString("Departure address and Destination address should not be the same", comment: "Alert text if user chosed the same cities"))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            apiRequester.postOrderAsDriver(apiRequester.user!.id!,
                source: fromCityTextField.text!,
                destination: toCityTextField.text!,
                passCount: passengersCountField.text!,
                duedate: dateOfDepartureField.text!,
                departTime: tripDepartureTimeField.text!,
                vehicleModel: vehicleModelField.text!,
                price: tripPriceField.text!)
        }
    }
    
    @IBAction func uploadPhotoButtonTapped(sender: UIButton) {
        let alert = Utilities.showOKAlert("Under", message: "Construction")
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func onDriverPostedOrder(notification: NSNotification) {
        var title = ""
        var message = ""
        
        switch (notification.object!.integerValue) {
        case OPERATION_FAILED:
            title = NSLocalizedString("Error", comment: "Alert title if error happened when driver creates order")
            message = NSLocalizedString("Something went wrong. Please, try later", comment: "Alert message if error happened when driver creates order")
            break
        case OPERATION_SUCCESS..<Int.max:
            title = NSLocalizedString("Success", comment: "Alert title if driver succesfully created queue")
            message = NSLocalizedString("Your order successfully created", comment: "Alert message if error happened when driver creates order")
            break
        case NO_ENOUGH_BALANCE:
            title = NSLocalizedString("Warning", comment: "Alert title if driver has no enough money")
            message = NSLocalizedString("You don't have enough money, Please fill your balance", comment: "Alert message if driver has no enough money")
            break
        case DATE_BEFORE_TODAY:
            title = NSLocalizedString("Error", comment: "Alert title if driver selected wrong date")
            message = NSLocalizedString("Please, choose a date after today", comment: "Alert message if driver chossed wrong date")
            break
        default:
            print("recieved smth else then known statuses")
            print(notification.object?.integerValue)
            break
        }
    
        let alert = Utilities.showOKAlert(title, message: message)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
