//
//  CreateOrderDriverViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 12/21/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit
import MobileCoreServices

class CreateOrderDriverViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    @IBOutlet weak var cancelOrderButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var controller: UIImagePickerController?
    private var apiRequester = APIRequester.sharedInstance
    private var activeTextField = UITextField()
    private var chosenImage: UIImage?
    private let utilities = Utilities()
    private var customPickerView: UIPickerView?
    private var fromCity = ""
    private var toCity = ""
    
    private let OPERATION_FAILED = -1
    private let OPERATION_SUCCESS = 0
    private let NO_ENOUGH_BALANCE = -2
    private let DATE_BEFORE_TODAY = -3
    
    //Cancel queue  statuses
    private let OPERATION_NOT_APPLICABLE = -4
    private let NON_EXISTANT_OBJECT = -3

    var isUserEditing = false
    
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
        
        placeOrderButton.hidden = isUserEditing
        cancelOrderButton.hidden = !isUserEditing
        
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
            selector: #selector(CreateOrderDriverViewController.onDriverPostedOrder(_:)),
            name: Variables.Notifications.PostOrderDriver,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(CreateOrderDriverViewController.onDriverCancelledOrder(_:)),
            name: Variables.Notifications.DriverQueueCancelled,
            object: nil)
        passengersCountField.text = Int(countOfPassengersStepper.value).description
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
            customPickerView = UIPickerView()
            customPickerView!.delegate = self
            customPickerView!.dataSource = self
            textField.inputView = customPickerView
            let customToolBar = utilities.getToolBar()
            customToolBar.targetForAction(Selector("donePicker"), withSender: self)
            textField.inputAccessoryView = customToolBar
        }
        else if textField == dateOfDepartureField {
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.Date
            let oneDay: NSTimeInterval = 60 * 60 * 24;
            let twoDaysFromNow = NSDate(timeIntervalSinceNow: oneDay * 2)
            datePickerView.minimumDate = twoDaysFromNow
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(CreateOrderDriverViewController.datePickerAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
            let customToolBar = utilities.getToolBar()
            customToolBar.targetForAction(Selector("donePicker"), withSender: self)
            textField.inputAccessoryView = customToolBar
        }
        
        return true
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
        else if checkRareRoute(true) {
        
        }
        else {
            makeTrip()
        }
    }
    
    @IBAction func cancelOrderButtonTapped(sender: UIButton) {
        
    }
    
    func onDriverPostedOrder(notification: NSNotification) {
        var title = ""
        var message = ""
        hideProgressHud()
        let operationValue = notification.object!.integerValue
        switch (operationValue) {
        case OPERATION_FAILED:
            title = NSLocalizedString("Error", comment: "Alert title if error happened when driver creates order")
            message = NSLocalizedString("Something went wrong. Please, try later", comment: "Alert message if error happened when driver creates order")
            break
        case OPERATION_SUCCESS..<Int.max:
            title = NSLocalizedString("Success", comment: "Alert title if driver succesfully created queue")
            message = NSLocalizedString("Your order successfully created", comment: "Alert message if error happened when driver creates order")
            if chosenImage != nil {
                apiRequester.uploadDriverVehiclePhotoByQueueId(operationValue, image: chosenImage!)
            }
            refreshOrderForm()
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
            print("recieved smth else then known statuses", terminator: "")
            print(notification.object?.integerValue, terminator: "")
            break
        }
    
        let alert = Utilities.showOKAlert(title, message: message)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func onDriverCancelledOrder(notification: NSNotification) {
        print(notification.object as! Int, terminator: "")
    }
    
    //MARK: Upload image methods
    @IBAction func uploadPhotoButtonTapped(sender: UIButton) {
        openPhotoGallery()
    }
    
    func openPhotoGallery() {
        let alertController = UIAlertController(
            title: nil,
            message: NSLocalizedString("Add photoes of your vehicle", comment: "Alert title on choosing picutre on creating Ad page"),
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Take photo", comment: "Take Photo from camera"),
            style: .Default,
            handler: {(action: UIAlertAction) in
                self.openLibrary(UIImagePickerControllerSourceType.Camera)
        }))
        
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Photo library", comment: "Take photo from library"),
            style: .Default,
            handler: {(action: UIAlertAction) in
                self.openLibrary(UIImagePickerControllerSourceType.PhotoLibrary)
        }))
        
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Dismiss", comment: "Dismiss alert action shit on upload photo"),
            style: .Default,
            handler: nil
            ))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    func cameraSupportsMedia(mediaType: String, sourceType: UIImagePickerControllerSourceType) -> Bool {
        if let availableMediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType) as [String]? {
            for type in availableMediaTypes {
                if type == mediaType {
                    return true
                }
                return true
            }
        }
        return false
    }
    
    func doesCameraSupportShootingVideos() -> Bool {
        return cameraSupportsMedia(kUTTypeMovie as String, sourceType: .Camera)
    }
    
    func doesCameraSupportTakingPhotos() -> Bool {
        return cameraSupportsMedia(kUTTypeImage as String, sourceType: .Camera)
    }
    
    func isFrontCameraAvailable() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(.Front)
    }
    
    func isRearCameraAvailable() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(.Rear)
    }
    
    func isFlashAvailableOnFrontCamera() -> Bool {
        return UIImagePickerController.isFlashAvailableForCameraDevice(.Front)
    }
    
    func isFlashAvailableOnRearCamera() -> Bool{
        return UIImagePickerController.isFlashAvailableForCameraDevice(.Rear)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
        if let type:AnyObject = mediaType {
            if type is String {
                let stringType = type as! String
                if stringType == kUTTypeMovie as NSString {
                    let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
                    if let url = urlOfVideo {
                        print("Video URL = \(url)", terminator: "")
                    }
                }
                else if stringType == kUTTypeImage as NSString {
                    let image: AnyObject? = info[UIImagePickerControllerOriginalImage]
                    
                    if let theImage: AnyObject = image {
                        chosenImage = Utilities.rotateCameraImageToProperOrientation(theImage as! UIImage, maxResolution: 640)
                        vehiclePhotoUploadButton.setTitle(NSLocalizedString("Photo chosen", comment: "Image upload button title on driver info view when image already chosen"), forState: .Normal)
                    }
                }
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func openLibrary(sourceType: UIImagePickerControllerSourceType) {
        if isCameraAvailable() && doesCameraSupportTakingPhotos() {
            controller = UIImagePickerController()
            if let theController = controller {
                theController.mediaTypes = [kUTTypeImage as String]
                theController.allowsEditing = true
                theController.delegate = self
                theController.sourceType = sourceType
                self.presentViewController(theController, animated: true, completion: nil)
            }
            else {
                print("Camera is not available", terminator: "")
            }
        }
    }
    
    func donePicker(sender: AnyObject) {
        view.endEditing(true);
        
        if let selectedRow = customPickerView?.selectedRowInComponent(0) {
            switch activeTextField {
            case fromCityTextField:
                fromCity = apiRequester.cities![selectedRow].name
                fromCityTextField.text = NSLocalizedString(apiRequester.cities![selectedRow].name, comment: "City name in textField")
                checkSameCity()
                checkRareRoute(false)
                break
            case toCityTextField:
                toCity = apiRequester.cities![selectedRow].name
                toCityTextField.text = NSLocalizedString(apiRequester.cities![selectedRow].name, comment: "City name in textField")
                checkSameCity()
                checkRareRoute(false)
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
        vehicleModelField.text = nil
        tripPriceField.text = nil
        tripDepartureTimeField.text = nil
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(CreateOrderDriverViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(CreateOrderDriverViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
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
        self.apiRequester.postOrderAsDriver(apiRequester.user!.id!,
            source: self.fromCity,
            destination: self.toCity,
            passCount: self.passengersCountField.text!,
            duedate: self.dateOfDepartureField.text!,
            departTime: self.tripDepartureTimeField.text!,
            vehicleModel: self.vehicleModelField.text!,
            price: self.tripPriceField.text!)
    }
    
    func checkSameCity() -> Bool {
        if toCity == fromCity {
            let alert = Utilities.showOKAlert(NSLocalizedString("Error", comment: "Alert title if error happened"),
                message: NSLocalizedString("Departure address and Destination address should not be the same", comment: "Alert text if user chosed the same cities"))
            self.presentViewController(alert, animated: true, completion: nil)
            if activeTextField == toCityTextField {
                toCity = ""
            }
            else {
                fromCity = ""
            }
            activeTextField.text = nil
            return true
        }
        
        return false
    }
    
    func checkRareRoute(isMakeOrderButtonTapped: Bool) -> Bool {
        if (fromCity != "" && fromCity != "Душанбе" && toCity != "" && toCity != "Душанбе") {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert title when user choose rare route"),
                message: NSLocalizedString("There is a few trips in a month for this route. Do you want to continue" + "?", comment: "Warning message in alert when user choose rare route"), preferredStyle: .Alert)
            
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
                }
            })
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
            return true
        }
        
        return false
    }
}
