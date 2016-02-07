//
//  DriverClientsTableViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 1/25/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit

class DriverClientsTableViewController: UITableViewController {
    
    private let apiRequester = APIRequester.sharedInstance
    private var driverClients = [DriverClient]()
    private var reuseIdentifier = "ClientQueueCellIdentifier"
    
    var driverQueue: DriverQueue?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Passengers", comment: "Driver order passengers view title")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let clientQueueCellNib = UINib(nibName: "ClientQueueTableViewCell", bundle: nil)
        tableView.registerNib(clientQueueCellNib, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "dismissView")
        
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onDriverClientsLoaded:",
            name: Variables.Notifications.DriverClients,
            object: nil)
        
        if let driverQueueId = driverQueue?.id {
            apiRequester.getDriverClientsByQueueId(driverQueueId)
        }
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    func dismissView() {
        UIApplication.sharedApplication().statusBarStyle = .Default
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(Variables.Notifications.DriverClients)
    }
    
    func onDriverClientsLoaded(notification: NSNotification) {
        print(notification)
        
        if let driverClients = notification.object as? [DriverClient] {
            self.driverClients = driverClients
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return driverClients.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ClientQueueTableViewCell
        
        //Configure the cell...
        cell.passengersCountLabel.text = NSLocalizedString("Passengers", comment: "Passegners count on client queues cell") + ": " + driverClients[indexPath.row].count.description
        cell.dateLabel.text = driverClients[indexPath.row].phoneNo
        cell.directionLabel.text = driverClients[indexPath.row].fullName

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        alert.title = NSLocalizedString("Calling", comment: "ALert title when driver wants to call to passenger")
        
        alert.message = NSLocalizedString("Call to", comment: "ALert description when driver wants to call to passenger")
            + ": " + driverClients[indexPath.row].fullName + "?"
        
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: "Action sheet on client queues button about driver"),
            style: .Default, handler: {(alert: UIAlertAction!) in
          Utilities.callToNumber(self.driverClients[indexPath.row].phoneNo)
        })
        
        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: "Action sheet on client queues button edit"),
            style: .Default, handler: nil)
    
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
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
