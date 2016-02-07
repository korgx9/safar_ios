//
//  DriverClient.swift
//  Travel Queue
//
//  Created by Kesh Pola on 1/26/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit
import ObjectMapper

class DriverClient: NSObject, Mappable {

    var count: Int = 0
    var phoneNo: String = ""
    var fullName: String = ""
    
    init?(count: Int, phoneNo: String, fullName: String) {
        // Initialize stored properties.
        self.count = count
        self.phoneNo = phoneNo
        self.fullName = fullName
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.count      <- map["count"]
        self.phoneNo    <- map["phoneNo"]
        self.fullName   <- map["fullName"]
    }
}
