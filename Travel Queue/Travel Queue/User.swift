//
//  User.swift
//  Travel Queue
//
//  Created by Kesh Pola on 12/19/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit
import ObjectMapper

class User: NSObject, Mappable {
    // MARK: Properties

    var id: Int?
    var name: String?
    var surname: String?
    var phonenumber: String?
    var password: String?
    var status: Int?

    init?(id: Int, name: String, surname: String, phonenumber: String, password: String, status: Int) {
        // Initialize stored properties.
        self.id = id
        self.name = name
        self.surname = surname
        self.phonenumber = phonenumber
        self.password = password
        self.status = status
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        surname     <- map["surname"]
        phonenumber <- map["phonenumber"]
        password    <- map["password"]
        status      <- map["status"]
    }
}