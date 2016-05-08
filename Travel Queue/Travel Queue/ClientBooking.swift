//
//  ClientBooking.swift
//  Travel Queue
//
//  Created by Kesh Pola on 5/1/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit
import ObjectMapper

class ClientBooking: Mappable {
    var reservationId = 0
    var status = 0
    var curDQ: DriverQueue?
    
    init() {}
    
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        self.reservationId  <- map["reservationid"]
        self.status         <- map["status"]
        self.curDQ          <- map["curDQ"]
    }
}