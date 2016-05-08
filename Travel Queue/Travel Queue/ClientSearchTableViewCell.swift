//
//  ClientSearchTableViewCell.swift
//  Travel Queue
//
//  Created by Kesh Pola on 5/9/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit

class ClientSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var vehicleNameLabel: UILabel!
    @IBOutlet weak var totalSeatsLabel: UILabel!
    @IBOutlet weak var availableSeatsLabel: UILabel!
    @IBOutlet weak var availableSeatsTextLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 3.0
        
        vehicleImage.layer.masksToBounds = false
        vehicleImage.clipsToBounds = true
        
        if availableSeatsLabel.text == "3" ||
        availableSeatsLabel.text == "2" ||
        availableSeatsLabel.text == "1"{
        availableSeatsTextLabel.textColor = UIColor.redColor().colorWithAlphaComponent(0.6)
            availableSeatsLabel.textColor = UIColor.redColor().colorWithAlphaComponent(0.6)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        print("Selected")
        
    }
    
}
