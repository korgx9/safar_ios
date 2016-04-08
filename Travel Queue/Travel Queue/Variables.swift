//
//  Variables.swift
//  Travel Queue
//
//  Created by Kesh Pola on 10/7/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit

struct Variables {
    struct Notifications {
        static let NoInternet               = "NoInternetNotificationKey"
        static let Login                    = "LoginNotificationKey"
        static let Regiser                  = "RegisterNotificationKey"
        static let Activate                 = "ActivateNotificationKey"
        static let UserLoaded               = "UserLoadedNotificationKey"
        static let PostOrderClient          = "PostOrderClientNotificationKey"
        static let PostOrderDriver          = "PostOrderDriverNotificationKey"
        static let UserQueuesAsClientLoaded = "UserQueuesAsClientLoadedNotificationKey"
        static let UserQueuesAsDriverLoaded = "UserQueuesAsDriverLoadedNotificationKey"
        static let DriverInfo               = "DriverInfoNotificationKey"
        static let ConfirmDriver            = "ConfirmDriverNotificationKey"
        static let RejectDriver             = "RejectDriverNotificationKey"
        static let DriverClients            = "DriverClientsNotificationKey"
        static let DriverQueueCancelled     = "DriverQueueCancelledNotificationKey"
        static let ClientQueueCancelled     = "ClientQueueCancelledNotificationKey"
    }
    
//    static let cities = ["", "Душанбе", "Хорог", "Куляб", "Ходжент"]
    
    struct Colors {
        struct NavigationBar {
            static let Text = Utilities.getUIColorFromHex(0xE7E7E7)
            static let Tint = Utilities.getUIColorFromHex(0xE7E7E7)
            static let Background = Utilities.getUIColorFromHex(0x2C2A25)
        }
        
        struct TabBar {
            static let Tint = Utilities.getUIColorFromHex(0xFFDC00)
            static let Background = Utilities.getUIColorFromHex(0x2C2A25)
            
            struct Item {
                static let TextNormal = UIColor.lightGrayColor()
                static let TextSelected = Utilities.getUIColorFromHex(0xFFDC00)
            }
        }
        
        struct SegmentSwitcher {
            static let Tint = Utilities.getUIColorFromHex(0x4D4D4B)
            static let Background = Utilities.getUIColorFromHex(0xE7E7E7)
        }
    }
    
    struct Status {
        struct Error {
            static let NoInternet = -1004
            static let NoInternet1 = -1009
            static let ConnectionLost = -1005
            static let BadRequest = -6003
        }
    }
}