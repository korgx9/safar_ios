//
//  DriverListCellTableViewCell.swift
//  Travel Queue
//
//  Created by Kesh Pola on 4/23/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit

class DriverListCellTableViewCell: UITableViewCell {

    @IBOutlet weak var vehicleNameLabel: UILabel!
    @IBOutlet weak var availableSeatsCountLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var priceForASeatLabel: UILabel!
    @IBOutlet weak var vehicleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        vehicleImage.clipsToBounds = false
        vehicleImage.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
