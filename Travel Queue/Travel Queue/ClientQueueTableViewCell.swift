//
//  ClientQueueTableViewCell.swift
//  Travel Queue
//
//  Created by Kesh Pola on 1/3/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit

class ClientQueueTableViewCell: UITableViewCell {
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var passengersCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
