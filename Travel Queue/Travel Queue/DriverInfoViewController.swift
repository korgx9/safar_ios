//
//  DriverInfoViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 1/21/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit
import SDWebImage

class DriverInfoViewController: UIViewController {
    @IBOutlet weak var driverFullNameField: UITextField!
    @IBOutlet weak var driverPhoneNumberField: UITextField!
    
    @IBOutlet weak var vehicleModelField: UITextField!
    @IBOutlet weak var vehiclePlateNumberField: UITextField!
    @IBOutlet weak var carSeatPriceField: UITextField!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var acceptDriverButton: UIButton!
    @IBOutlet weak var declineDriverButton: UIButton!

    var queue: Queue?
    
    private let apiRequester = APIRequester.sharedInstance
    private var driverInfo: DriverInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = NSLocalizedString("Driver details", comment: "About driver view title")
        
        acceptDriverButton.layer.cornerRadius = 3.0
        declineDriverButton.layer.cornerRadius = 3.0
        
        let myBackButton:UIButton = UIButton()
        myBackButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle(NSLocalizedString("Back", comment: "Navigation back button on about driver view"), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        vehicleImage.clipsToBounds = false
        vehicleImage.layer.masksToBounds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onDriverInfoLoaded:",
            name: Variables.Notifications.DriverInfo,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onDriverConfirmed:",
            name: Variables.Notifications.ConfirmDriver,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onDriverRejected:",
            name: Variables.Notifications.RejectDriver,
            object: nil)
     
        if let queueId = queue?.id {
            apiRequester.getDriverInfoByClientOrderId(queueId)
        }
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.DriverInfo)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    func onDriverInfoLoaded(notification: NSNotification) {
        if let driverInfo = notification.object as? DriverInfo {
            driverFullNameField.text = driverInfo.name + " " + driverInfo.surname
            driverPhoneNumberField.text = driverInfo.phonenumber
            
            vehicleModelField.text = driverInfo.carModel
            carSeatPriceField.text = driverInfo.price.description
            self.driverInfo = driverInfo
            
            apiRequester.downloadDriverVehicleImageByQueueId(driverInfo.dqid, imageView: vehicleImage)
        }
    }
    
    func onDriverConfirmed(notification: NSNotification) {
        print(notification)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onDriverRejected(notification: NSNotification) {
        print(notification)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptDriverButtonTapped(sender: AnyObject) {
        if let queueId = queue?.id {
            if let dqueueId = driverInfo?.dqid {
                apiRequester.confirmDriver(queueId, dqid: dqueueId)
            }
        }
    }

    @IBAction func rejectDriverButtonTapped(sender: AnyObject) {
        if let queueId = queue?.id {
            if let dqueueId = driverInfo?.dqid {
                apiRequester.rejectDriver(queueId, dqid: dqueueId, reason: "")
            }
        }
    }
    
    func popToRoot(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
