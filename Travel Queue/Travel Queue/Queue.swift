//
//  Queue.swift
//  Travel Queue
//
//  Created by Kesh Pola on 12/28/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit
import ObjectMapper

class Queue: NSObject, Mappable {
    // MARK: Properties
    
    var id = 0
    var clientid: Int?
    var source: String?
    var destination: String?
    var status: Int?
    var pickup: Bool?
    var remarks: String?
    var address: String?
    var duedate: String?
    var numberofPassengers: Int?
    
    init?(id: Int, clientid: Int, source: String, destination: String, status: Int, pickup: Bool, remarks: String, address: String, duedate: String, numberofPassengers: Int) {
        // Initialize stored properties.
        self.id = id
        self.clientid = clientid
        self.source = source
        self.destination = destination
        self.status = status
        self.pickup = pickup
        self.remarks = remarks
        self.address = address
        self.duedate = duedate
        self.numberofPassengers = numberofPassengers
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id                 <- map["id"]
        self.clientid           <- map["clientid"]
        self.source             <- map["source"]
        self.destination        <- map["destination"]
        self.status             <- map["status"]
        self.pickup             <- map["pickup"]
        self.remarks            <- map["remarks"]
        self.address            <- map["address"]
        self.duedate            <- map["duedate"]
        self.numberofPassengers <- map["numberofPassengers"]
    }
}
