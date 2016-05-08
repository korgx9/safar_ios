//
//  DriversListTableViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 4/23/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit

class DriversListTableViewController: UITableViewController {
    private let apiRequester = APIRequester.sharedInstance
    private let reuseIdentifierDriverCell = "ClientSearchCell"
    
    var driverQueueList = [DriverQueue]()
    var bookedSeatsCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let driverCell = UINib(nibName: "ClientSearchTableViewCell", bundle: nil)
        tableView.registerNib(driverCell, forCellReuseIdentifier: reuseIdentifierDriverCell)
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let myBackButton:UIButton = UIButton()
        myBackButton.addTarget(self, action: #selector(DriverInfoViewController.popToRoot(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle(NSLocalizedString("Back", comment: "Navigation back button on about driver view"), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        self.navigationController?.navigationBar.barTintColor = Utilities.getUIColorFromHex(0x007AFF)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
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
        
        return driverQueueList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let order = driverQueueList[row]
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifierDriverCell, forIndexPath: indexPath) as! ClientSearchTableViewCell
        
        cell.directionLabel.text = "\(order.source) - \(order.destination)"
        cell.dateLabel.text = NSLocalizedString("Date", comment: "Date text on search result cell") + ": " + order.duedate
        cell.priceLabel.text = order.price.description
        cell.vehicleImage.sd_setImageWithURL(NSURL(string: "http://safar.tj:8080/getImageforDq/" + order.id.description), placeholderImage: UIImage(named: "noPhoto"), options: .RetryFailed)
        cell.vehicleNameLabel.text = order.carModel
        cell.totalSeatsLabel.text = order.numberofPassengers.description
        cell.availableSeatsLabel.text = order.remainedSeats.description
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("DriverDetailsToBook") as! DriverDetailsToBookViewController
        vc.queue = driverQueueList[indexPath.row]
        vc.chosenSeats = bookedSeatsCount
        self.navigationController?.pushViewController(vc, animated: true)
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
    
//    // MARK: - Signal Listeners
//    func subscribeToListeners() {
//        apiRequester.onSearchResult.listen(self) { orders in
//            self.orders = orders
//            self.tableView.reloadData()
//            hideProgressHud()
//        }
//    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("segue = \(segue)")
        print("sender = \(sender)")
        
//        let secondViewController = segue.destinationViewController as! AdvDetailsViewController
//        secondViewController.order = sender as! Order
    }
    
    func popToRoot(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
