//
//  SwitcherQueueViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 11/2/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit

class SwitcherQueueViewController: UIViewController {

    @IBOutlet weak var segmentSwitcher: UISegmentedControl!
    @IBOutlet weak var ordersAsPassengerListContainer: UIView!
    @IBOutlet weak var ordersAsDriverListContainer: UIView!
    
    var interfaceToView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SwitcherQueueViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeUserScreen(sender: AnyObject) {
        if interfaceToView {
            interfaceToView = false
            switchInterface()
        }
        else {
            interfaceToView = true
            switchInterface()
        }
    }
    
    func switchInterface() {
        switch interfaceToView {
        case true :
            UIView.transitionWithView(view,
                duration: 0.5,
                options: UIViewAnimationOptions.TransitionCurlDown,
                animations: {
                    self.view.bringSubviewToFront(self.ordersAsPassengerListContainer)
                },
                completion: {
                    finished in
            })
            break
        case false:
            UIView.transitionWithView(view,
                duration: 0.5,
                options: UIViewAnimationOptions.TransitionCurlUp,
                animations: {
                    self.view.bringSubviewToFront(self.ordersAsDriverListContainer)
                },
                completion: {
                    finished in
            })
            break
        }
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
}
