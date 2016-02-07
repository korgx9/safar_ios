//
//  SwitcherViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 11/1/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit

class SwitcherViewController: UIViewController {
    @IBOutlet weak var segmentController: UISegmentedControl!

    @IBOutlet weak var passengerContainer: UIView!
    @IBOutlet weak var driverContainer: UIView!
    
    var interfaceToView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
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
                options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: {
                    self.view.bringSubviewToFront(self.passengerContainer)
                },
                completion: {
                    finished in
            })
            break
        case false:
            UIView.transitionWithView(view,
                duration: 0.5,
                options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: {
                    self.view.bringSubviewToFront(self.driverContainer)
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
