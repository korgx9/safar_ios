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
    private let utilities = Utilities()
    
    var driverQueue: DriverQueue?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Passengers", comment: "Driver order passengers view title")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController?.navigationBar.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.1)
        
        let clientQueueCellNib = UINib(nibName: "ClientQueueTableViewCell", bundle: nil)
        tableView.registerNib(clientQueueCellNib, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let doneBarButton = UIBarButtonItem(title: NSLocalizedString("Close", comment: "Close button title on passengers list view"),
            style: UIBarButtonItemStyle.Done, target: self, action: "dismissView")
        
        navigationItem.leftBarButtonItem = doneBarButton
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
        
//        UIApplication.sharedApplication().statusBarStyle = .LightContent
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
        print(notification, terminator: "")
        
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
        cell.statusImage.image = UIImage(named: "call")

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        alert.title = NSLocalizedString("Calling", comment: "ALert title when driver wants to call to passenger")
        
        alert.message = NSLocalizedString("Call to", comment: "ALert description when driver wants to call to passenger")
            + ": " + driverClients[indexPath.row].fullName + "?"
        
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: "Action sheet on client queues button about driver"),
            style: .Default, handler: {(alert: UIAlertAction) in
          Utilities.callToNumber(self.driverClients[indexPath.row].phoneNo)
        })
        
        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: "Action sheet on client queues button edit"),
            style: .Default, handler: nil)
    
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    /*
     Ещё надо Добавить Душанбе - Турсунзаде, Душанбе-Куляб, Душанбе -Кургантеппа, Душанбе- Вахдат, Душанбе- Ромит! И Душанбе-Варзоб
     */
}
