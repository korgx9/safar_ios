//
//  EditDriverQueueViewController.swift
//  Travel Queue
//
//  Created by Kesh Pola on 5/6/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit
//import Fashion

class EditDriverQueueViewController: UIViewController {
    @IBOutlet weak var roomCountField: UILabel!
    @IBOutlet weak var roomCountStepper: UIStepper!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var roomCount = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        roomCountStepper.value = roomCount
        roomCountField.text = Int(roomCount).description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func roomCountStepperValueChanged(sender: AnyObject) {
        let stepper = sender as! UIStepper
        roomCountField.text = Int(stepper.value).description
    }
    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func confirmButtonTapped(sender: AnyObject) {
        print(" 11 ")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
