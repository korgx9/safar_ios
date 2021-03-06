//
//  DriverQueuesTableViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 1/4/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit

class DriverQueuesTableViewController: UITableViewController {

    private var apiRequester = APIRequester.sharedInstance
    private var queues: [DriverQueue]?
    private var clientQueueCellIdentifier   = "ClientQueueCellIdentifier"
    
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
        
        let tap = UITapGestureRecognizer(target: self, action:Selector("dismissKeyboard"))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    func dismissKeyboard() {}
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        apiRequester.getUserQueuesAsDriverById(apiRequester.user!.id!)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onUserQueuesAsDriverLoaded:",
            name: Variables.Notifications.UserQueuesAsDriverLoaded,
            object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.UserQueuesAsClientLoaded)
    }
    
    func onUserQueuesAsDriverLoaded(notification: NSNotification) {
        self.queues = notification.object as? [DriverQueue]
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
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
        cell.passengersCountLabel.text = NSLocalizedString("Passengers Left", comment: "Passegners count on client queues cell") + ": " + queues![indexPath.row].remainedSeats.description
        cell.dateLabel.text = NSLocalizedString("Date", comment: "Travel date on client queue cell") + ": " + queues![indexPath.row].duedate
        cell.directionLabel.text = "\(queues![indexPath.row].source) - \(queues![indexPath.row].destination)"
        //        cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        
        print("Driver order status = \(queues![indexPath.row].status)")
        
        switch queues![indexPath.row].status {
        case ORDER_COMPLETED:
            cell.statusImage.image = UIImage(named: "statusCompleted")
            break
        case ORDER_PARTIAL_COMPLETED:
            cell.statusImage.image = UIImage(named: "statusCompleted")
            break
        case ORDER_NEW:
            cell.statusImage.image = UIImage(named: "statusWaiting")
            break
        case ORDER_CANCELLED:
            cell.statusImage.image = UIImage(named: "statusCanceled")
            break
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let queue = queues?[indexPath.row] {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let showPassengersAction = UIAlertAction(title: NSLocalizedString("Show passengers", comment: "Action sheet on client queues button about driver"),
                style: .Default, handler: {(alert: UIAlertAction!) in
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let driverDetailsViewController = storyboard.instantiateViewControllerWithIdentifier("DriverClients") as! DriverClientsTableViewController
                    driverDetailsViewController.driverQueue = queue
                    let clientsNavCon = UINavigationController.init(rootViewController: driverDetailsViewController)
                    self.presentViewController(clientsNavCon, animated: true, completion: nil)
            })
            
            let editAction = UIAlertAction(title: NSLocalizedString("Edit", comment: "Action sheet on client queues button edit"),
                style: .Default, handler: nil)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Action sheet on client queues button cancel"),
                style: .Default, handler: nil)
            
            if queues![indexPath.row].status != ORDER_NEW {
                alert.addAction(showPassengersAction)
            }
            else {
                alert.addAction(editAction)
            }
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
