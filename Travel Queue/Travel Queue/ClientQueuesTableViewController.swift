//
//  ClientQueuesTableViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 12/28/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit

class ClientQueuesTableViewController: UITableViewController {

    private var apiRequester = APIRequester.sharedInstance
    private var queues: [ClientBooking]?
    private var clientQueueCellIdentifier = "ClientQueueCellIdentifier"
    private let utilities = Utilities()
    
    /************Statuses**********/
    private let ORDER_COMPLETED = 0
    private let ORDER_PARTIAL_COMPLETED = 1
    private let ORDER_WAITING_CONFIRMATION = 2
    private let ORDER_NEW = 3
    private let ORDER_CANCELLED = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let clientQueueCellNib = UINib(nibName: "ClientQueueTableViewCell", bundle: nil)
        tableView.registerNib(clientQueueCellNib, forCellReuseIdentifier: clientQueueCellIdentifier)
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(ClientQueuesTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.UserQueuesAsClientLoaded)
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.ClientQueueCancelled)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ClientQueuesTableViewController.onUserQueuesAsClientLoaded(_:)),
            name: Variables.Notifications.UserQueuesAsClientLoaded,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ClientQueuesTableViewController.onUserCancelledOrder(_:)),
            name: Variables.Notifications.ClientQueueCancelled,
            object: nil)
        apiRequester.getUserReservations(apiRequester.user!.id!)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.UserQueuesAsClientLoaded)
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.ClientQueueCancelled)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    func dismissKeyboard() {}
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (queues == nil) {
            return 0
        }
        
        return queues!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(clientQueueCellIdentifier, forIndexPath: indexPath) as! ClientQueueTableViewCell

        //Configure the cell...
        cell.passengersCountLabel.text = NSLocalizedString("Passengers Left", comment: "Passegners count on client queues cell") + ": " + queues![indexPath.row].curDQ!.remainedSeats.description
        cell.dateLabel.text = NSLocalizedString("Date", comment: "Travel date on client queue cell") + ": " + queues![indexPath.row].curDQ!.duedate
        cell.directionLabel.text = "\(NSLocalizedString(queues![indexPath.row].curDQ!.source, comment: "")) - \(NSLocalizedString(queues![indexPath.row].curDQ!.destination, comment: ""))"
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.statusImage.sd_setImageWithURL(NSURL(string: "http://safar.tj:8080/getImageforDq/" +  queues![indexPath.row].curDQ!.id.description), placeholderImage: UIImage(named: "noPhoto"), options: .RetryFailed)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let queue = queues?[indexPath.row] {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let aboutDriverAction = UIAlertAction(title: NSLocalizedString("About Driver", comment: "Action sheet on client queues button about driver"),
                style: .Default, handler: {(alert: UIAlertAction) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let driverDetailsViewController = storyboard.instantiateViewControllerWithIdentifier("DriverInfo") as! DriverInfoViewController
//                    driverDetailsViewController.queue = queue.curDQ
                    let navigation = UINavigationController(rootViewController: driverDetailsViewController)
                    self.presentViewController(navigation, animated: true, completion: nil)
            })
            
//            let editAction = UIAlertAction(title: NSLocalizedString("Edit", comment: "Action sheet on client queues button edit"),
//                style: .Default, handler: nil)
            print(queue.reservationId)
            let cancelOrderAction = UIAlertAction(title: NSLocalizedString("Cancel Order", comment: "Action sheet on client queues button edit"),
                style: .Default, handler: { Void in
                    self.utilities.showProgressHud(NSLocalizedString("Request", comment: "HUD message when canceling user order"), forView: self.view)
                    self.apiRequester.cancelClientReservation(queue.reservationId)
            })

            let cancelAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Action sheet on client queues button dismiss"),
                style: .Cancel, handler: nil)

            if queue.status == ORDER_WAITING_CONFIRMATION {
                alert.addAction(aboutDriverAction)
            }
//            alert.addAction(editAction)
            alert.addAction(cancelOrderAction)
            alert.addAction(cancelAction)
            
            if queue.status != ORDER_CANCELLED || queue.status != ORDER_COMPLETED {
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func onUserQueuesAsClientLoaded(notification: NSNotification) {
        self.queues = notification.object as? [ClientBooking]
        tableView.reloadData()
    }
    
    func onUserCancelledOrder(notification: NSNotification) {
        utilities.hideProgressHud()
        apiRequester.getUserReservations(apiRequester.user!.id!)
    }
}
