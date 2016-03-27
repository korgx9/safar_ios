//
//  City.swift
//  Travel Queue
//
//  Created by Kesh Pola on 3/21/16.
//  Copyright © 2016 Kesh Soft. All rights reserved.
//

import UIKit
import ObjectMapper

class City: NSObject, Mappable {
    var id: Int = 0
    var name = ""
    
    init?(id: Int, name: String) {
        // Initialize stored properties.
        self.id = id
        self.name = name
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id      <- map["locationid"]
        self.name    <- map["location"]
    }
}
