
//
//  CreateOrderPassengerViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 12/20/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit

class CreateOrderPassengerViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var fromCityTextField: UITextField!
    @IBOutlet weak var toCityTextField: UITextField!
    @IBOutlet weak var dateOfDepartureField: UITextField!
    @IBOutlet weak var countOfPassengersStepper: UIStepper!
    @IBOutlet weak var passengersCountField: UITextField!
    @IBOutlet weak var pickupFromHomeSwitcher: UISwitch!
    @IBOutlet weak var placeOrderButton: UIButton!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var pickupAddressField: UITextField!

    private var apiRequester = APIRequester.sharedInstance
    private var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fromCityTextField.delegate = self
        toCityTextField.delegate = self
        dateOfDepartureField.delegate = self
        
        placeOrderButton.layer.cornerRadius = 3.0
        
        passengersCountField.text = "1"
        pickupAddressLabel.hidden = true
        pickupAddressField.hidden = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onUserPostedOrder:",
            name: Variables.Notifications.PostOrderClient,
            object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.PostOrderClient)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func passengersCountStepperValueChanged(sender: UIStepper) {
        passengersCountField.text = Int(sender.value).description
    }
    
    @IBAction func pickupAddressSwitcher(sender: UISwitch) {
        pickupAddressLabel.hidden = !sender.on
        pickupAddressField.hidden = !sender.on
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
        toCityTextField.text == "" || dateOfDepartureField.text == "" ||
            (pickupAddressField.hidden == false && pickupAddressField.text == "") {
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
            apiRequester.postOrderAsClient(apiRequester.user!.id!,
                source: fromCityTextField.text!,
                destination: toCityTextField.text!,
                passCount: passengersCountField.text!,
                duedate: dateOfDepartureField.text!,
                pickup: (pickupFromHomeSwitcher.on == true ? 1 : 0),
                address: pickupAddressField.text!
            )
        }
    }
    
    func onUserPostedOrder(sender: AnyObject) {
        let alert = Utilities.showOKAlert(NSLocalizedString("Success", comment: "Alert title if success"),
            message: NSLocalizedString("Your order successfully created", comment: "Alert text if client order successfully created"))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
