//
//  DriverQueue.swift
//  Travel Queue
//
//  Created by Kesh Pola on 1/5/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit
import ObjectMapper

class DriverQueue: NSObject, Mappable {
    // MARK: Properties
    var id = 0
    var driverId: Int = 0
    var duedate: String = ""
    var departTime = ""
    var source: String = ""
    var destination: String = ""
    var status: Int = 0
    var remainedSeats: Int = 0
    var remarks: String = ""
    var carModel: String = ""
    var plateNumber: String = ""
    var price: Int = 0
    var numberofPassengers: Int = 0
    
    init?(id: Int, driverId: Int, duedate: String, departTime: String, source: String, destination: String, status: Int, remainedSeats: Int, remarks: String, carModel: String, plateNumber: String, price: Int, numberofPassengers: Int) {
        // Initialize stored properties.
        self.id = id
        self.driverId = driverId
        self.duedate = duedate
        self.departTime = departTime
        self.source = source
        self.destination = destination
        self.status = status
        self.remainedSeats = remainedSeats
        self.remarks = remarks
        self.carModel = carModel
        self.plateNumber = plateNumber
        self.price = price
        self.numberofPassengers = numberofPassengers
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id                 <- map["id"]
        self.driverId           <- map["driverid"]
        self.duedate            <- map["duedate"]
        self.departTime         <- map["depart_time"]
        self.source             <- map["source"]
        self.destination        <- map["destination"]
        self.status             <- map["status"]
        self.remainedSeats      <- map["remained_seats"]
        self.remarks            <- map["remarks"]
        self.carModel           <- map["carmodel"]
        self.plateNumber        <- map["platenum"]
        self.price              <- map["price"]
        self.numberofPassengers <- map["numberofPassengers"]
    }
}