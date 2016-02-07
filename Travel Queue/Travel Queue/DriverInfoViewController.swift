//
//  DriverInfoViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 1/21/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit

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
        acceptDriverButton.layer.cornerRadius = 3.0
        declineDriverButton.layer.cornerRadius = 3.0
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
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.DriverInfo)
    }
    
    func onDriverInfoLoaded(notification: NSNotification) {
        if let driverInfo = notification.object as? DriverInfo {
            driverFullNameField.text = driverInfo.name + " " + driverInfo.surname
            driverPhoneNumberField.text = driverInfo.phonenumber
            
            vehicleModelField.text = driverInfo.carModel
            carSeatPriceField.text = driverInfo.price.description
            self.driverInfo = driverInfo
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
