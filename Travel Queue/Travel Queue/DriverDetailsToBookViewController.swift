//
//  DriverDetailsToBookViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 4/24/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit

class DriverDetailsToBookViewController: UIViewController {
    @IBOutlet weak var vehicleModelField: UITextField!
    @IBOutlet weak var carSeatPriceField: UITextField!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var acceptDriverButton: UIButton!
    @IBOutlet weak var bookingSeatCountField: UITextField!
    @IBOutlet weak var bookingSeatsStepper: UIStepper!
    @IBOutlet weak var availableSeatsLabel: UILabel!
    
    var queue: DriverQueue?
    var chosenSeats: Int = 1
    
    private let apiRequester = APIRequester.sharedInstance
    private var driverInfo: DriverInfo?
    private let utilities = Utilities()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        acceptDriverButton.layer.cornerRadius = 3.0
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        vehicleImage.clipsToBounds = false
        vehicleImage.layer.masksToBounds = true
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        vehicleImage.sd_setImageWithURL(NSURL(string: "http://safar.tj:8080/getImageforDq/" + queue!.id.description), placeholderImage: UIImage(named: "noPhoto"), options: .RetryFailed)
        
        vehicleModelField.text = queue?.carModel
        carSeatPriceField.text = queue?.price.description
        bookingSeatCountField.text = chosenSeats.description
        bookingSeatsStepper.value = Double(chosenSeats)
        bookingSeatsStepper.maximumValue = Double(queue!.remainedSeats)
        
        availableSeatsLabel.text = queue!.remainedSeats.description
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(DriverInfoViewController.onDriverConfirmed(_:)),
                                                         name: Variables.Notifications.BookedSeatInVehicle,
                                                         object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.BookedSeatInVehicle)
    }
    
    @IBAction func chosenSeatsStepperValueChanged(sender: UIStepper) {
        print(Int(sender.value).description)
        bookingSeatCountField.text = Int(sender.value).description
    }
    
    func onDriverConfirmed(notification: NSNotification) {
        print(notification.object, terminator: "")
        
        hideProgressHud()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptDriverButtonTapped(sender: AnyObject) {
        utilities.showProgressHud(NSLocalizedString("Request", comment: "HUD on creating passenger order"), forView: self.view)
        apiRequester.bookSeatInVehicle(apiRequester.user!.id!, dqId: queue!.id, count: Int(bookingSeatsStepper.value), remarks: " ")
    }
}
