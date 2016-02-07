//
//  DriverInfo.swift
//  Travel Queue
//
//  Created by Kesh Pola on 1/21/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit
import ObjectMapper

class DriverInfo: NSObject, Mappable {
    
    // MARK: Properties
    var dqid = 0
    var name = ""
    var surname = ""
    var phonenumber = ""
    var numberofPassengers: Int = 0
    var remainedSeats: Int = 0
    var price: Int = 0
    var carModel: String = ""
    var remarks: String = ""
    var plateNumber: String = ""
    
    init?(dqid: Int, name: String, surname: String, phonenumber: String, numberofPassengers: Int, remainedSeats: Int, price: Int, carModel: String, remarks: String, plateNumber: String) {
        // Initialize stored properties.
        self.dqid = dqid
        self.name = name
        self.surname = surname
        self.phonenumber = phonenumber
        self.numberofPassengers = numberofPassengers
        self.remainedSeats = remainedSeats
        self.price = price
        self.carModel = carModel
        self.remarks = remarks
        self.plateNumber = plateNumber
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.dqid               <- map["dqid"]
        self.name               <- map["name"]
        self.surname            <- map["surname"]
        self.phonenumber        <- map["phonenumber"]
        self.numberofPassengers <- map["numberofPassengers"]
        self.remainedSeats      <- map["remained_seats"]
        self.price              <- map["price"]
        self.carModel           <- map["carmodel"]
        self.remarks            <- map["remarks"]
        self.plateNumber        <- map["platenum"]
    }
}
