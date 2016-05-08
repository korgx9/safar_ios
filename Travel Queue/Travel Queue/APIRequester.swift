//
//  APIRequester.swift
//  Travel Queue
//
//  Created by Kesh Pola on 10/7/15.
//  Copyright © 2015 Kesh Soft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CryptoSwift
import ObjectMapper
import SDWebImage

class APIRequester {
    
    static let BASE_URL = "http://safar.tj:8080/"
    private let SALT = "skey"
    private let Register = BASE_URL + "register"
    private let UserActivate = BASE_URL + "user/activate/"
    private let Login = BASE_URL + "login/"
    private let Users = BASE_URL + "user/"
    private let AddToQueue = BASE_URL + "queue/add"
    private let AddToQueueAsDriver = BASE_URL + "dqueue/add"
    private let UserQueuesAsClientById = BASE_URL + "allqueue/"
    private let UserQueuesAsDriverById = BASE_URL + "alldqueue/"
    private let CitiesURL = BASE_URL + "locations2/"
    private let CancelDQueue = BASE_URL + "dcancel/"
    private let CancelCQueue = BASE_URL + "ccancel/"
    private let DeviceTokenURL = BASE_URL + "usertoken/";//"/usertoken/{user_id}/{token}";"
    
    //TRIP
    private let TripConfirm = BASE_URL + "confirmtrip/"
    private let TripReject = BASE_URL + "rejecttrip/"
    private let DriverInfoByClientQueueId = BASE_URL + "getDqueuByCq/"
    private let DriverClientsByQueueId = BASE_URL + "getCqueuByDq/"
    private let DqByCqCompleted = BASE_URL + "getDqueuByCqCompleted/"
    private let DriverVehiclePhotoUpload = BASE_URL + "upload/"
    private let DriverVehiclePhotoDownload = BASE_URL + "getImageforDq/"
    
    
    //BASE URL V2
    static let BASE_URL_V2 = "http://safar.tj:8080/api/v2/"
    private let FindVehicleURL = BASE_URL_V2 + "findmatch/"
    private let BookSeatInVehicleURL = BASE_URL_V2 + "bookplace/"
    private let GetUserReservationsURL = BASE_URL_V2 + "userbookingmatchess/"
    private let EditReservationURL = BASE_URL + "editreserve/"//{queue_id}/{newcount}/
    private let CancelUserReservationsURL = BASE_URL_V2 + "cancelbooking/"//{reservation_id}
    
    
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    private let utilities = Utilities()
    
    var user: User?
    var cities: [City]?
    var deviceToken: String?
    
    class var sharedInstance: APIRequester {
        struct Static {
            static let instance: APIRequester = APIRequester()
        }
        
        return Static.instance
    }
    
    func register(username: String, password: String, name: String, surname: String) {
        let params = [
            "name": name,
            "surname": surname,
            "phonenumber": username,
            "password": password
        ]
        Alamofire.request(.POST, Register, parameters: params, encoding: .JSON).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    self.notificationCenter.postNotificationName(Variables.Notifications.Regiser, object: responseValue.integerValue)
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
    
    func activate(username: String, code: String) {
        Alamofire.request(.PUT, UserActivate + username + "/" + code).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    self.notificationCenter.postNotificationName(Variables.Notifications.Activate, object: responseValue.integerValue)
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }

    func login(username: String, password: String) {
        Alamofire.request(.GET, Login + username + "/" + (SALT + password).sha256(), parameters: nil, encoding: .JSON).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    // If cities didn't loaded
                    if self.cities?.count == 0 {
                        self.getCities()
                    }
                    if self.deviceToken != nil {
                        self.sendDeviceToken(username)
                    }
                    self.notificationCenter.postNotificationName(Variables.Notifications.Login, object: responseValue.integerValue)
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
    
    func sendDeviceToken(phone: String) {
        print(DeviceTokenURL + phone + "/" + deviceToken!, terminator: "")
        Alamofire.request(.POST, DeviceTokenURL + phone + "/" + deviceToken! , parameters: nil, encoding: .JSON).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                print(response.result.value)
                print("device token successfully sent")
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
    
    func getUserById(id: Int) {
        Alamofire.request(.GET, Users + id.description).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    self.user = Mapper<User>().map(responseValue)
                    self.notificationCenter.postNotificationName(Variables.Notifications.UserLoaded, object: self.user)
                }
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }

    func postOrderAsDriver(clientid: Int, source: String, destination: String, passCount: String, duedate: String, departTime: String, vehicleModel: String, price: String) {
        let params: [String : AnyObject] = [
            "clientid": clientid,
            "source": source,
            "destination": destination,
            "numberofpassengers": passCount,
            "duedate": duedate,
            "depart_time": departTime,
            "carmodel": vehicleModel,
            "remarks": "",
            "price": price
        ]
        Alamofire.request(.POST, AddToQueueAsDriver, parameters: params, encoding: .JSON).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    self.notificationCenter.postNotificationName(Variables.Notifications.PostOrderDriver, object: responseValue.integerValue)
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
    
//    func getUserQueuesAsClientById(id: Int) {
//        let orderCancelStatus = 4
//        Alamofire.request(.GET, UserQueuesAsClientById + id.description).validate().responseJSON {
//            response in
//            switch response.result {
//            case .Success:
//                if let responseValue = response.result.value {            
//                    let queues = Mapper<Queue>().mapArray(responseValue)
//                    
//                }
//                break
//            case .Failure(let error):
//                print(error)
//                break
//            }
//        }
//    }
    
    func getUserQueuesAsDriverById(id: Int) {
        let orderCancelStatus = 4
        Alamofire.request(.GET, UserQueuesAsDriverById + id.description).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    let queues = Mapper<DriverQueue>().mapArray(responseValue)
                    self.notificationCenter.postNotificationName(Variables.Notifications.UserQueuesAsDriverLoaded, object: queues?.filter({$0.status != orderCancelStatus}).reverse())
                }
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }
    
    func getDriverInfoByClientOrderId(id: Int) {
        Alamofire.request(.GET, DriverInfoByClientQueueId + id.description).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    let driverInfo = Mapper<DriverInfo>().map(responseValue)
                    self.notificationCenter.postNotificationName(Variables.Notifications.DriverInfo, object: driverInfo)
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
    
    func confirmDriver(cqid: Int, dqid: Int) {
        print(TripConfirm + cqid.description + "/" + dqid.description, terminator: "")
        Alamofire.request(.PUT, TripConfirm + cqid.description + "/" + dqid.description).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                print(response.result)
                if let responseValue = response.result.value {
                    let driverInfo = Mapper<DriverInfo>().map(responseValue)
                    self.notificationCenter.postNotificationName(Variables.Notifications.ConfirmDriver, object: driverInfo)
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
    
    func rejectDriver(cqid: Int, dqid: Int, reason: String) {
        Alamofire.request(.PUT, TripReject + cqid.description + "/" + dqid.description + "/" + reason).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                print(response.result)
                if let responseValue = response.result.value {
                    let driverInfo = Mapper<DriverInfo>().map(responseValue)
                    self.notificationCenter.postNotificationName(Variables.Notifications.RejectDriver, object: driverInfo)
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
    
    func getDriverClientsByQueueId(id: Int) {
        Alamofire.request(.GET, DriverClientsByQueueId + id.description).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    let driverClients = Mapper<DriverClient>().mapArray(responseValue)
                    self.notificationCenter.postNotificationName(Variables.Notifications.DriverClients, object: driverClients)
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
    
    func uploadDriverVehiclePhotoByQueueId(id: Int, image: UIImage) {
        Alamofire.upload(.POST, DriverVehiclePhotoUpload + id.description, multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(image, 98)!,
                    name: "file",
                    fileName: "driver_" + self.user!.id!.description + "_photo_" + id.description,
                    mimeType: "image/jpg")
            }, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .Failure(let encodingError):
                print(encodingError)
            }}
        )
    }
    
    func downloadDriverVehicleImageByQueueId(id: Int, imageView: UIImageView) {
//        let block: SDWebImageCompletionBlock! = {(image: UIImage?, error: NSError?, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//            print(image)
//            print(error)
//            print(imageURL)
//        }
//        print(DriverVehiclePhotoDownload + id.description)
//        imageView.sd_setImageWithURL(NSURL(string: DriverVehiclePhotoDownload + id.description), completed: block)
        imageView.sd_setImageWithURL(NSURL(string: DriverVehiclePhotoDownload + id.description), placeholderImage: UIImage(named: "noPhoto"), options: .RetryFailed)
    }
    
    func getCities() {
        Alamofire.request(.GET, CitiesURL).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    self.cities = Mapper<City>().mapArray(responseValue)
                }
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }
    
    func cancelDriverQueue(queueId: Int) {
        Alamofire.request(.PUT, CancelDQueue + queueId.description).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    self.notificationCenter.postNotificationName(Variables.Notifications.DriverQueueCancelled, object: responseValue.integerValue)
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
    
    func cancelClientQueue(queueId: Int) {
        print(CancelCQueue + queueId.description, terminator: "")
        Alamofire.request(.PUT, CancelCQueue + queueId.description).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    self.notificationCenter.postNotificationName(Variables.Notifications.ClientQueueCancelled, object: responseValue.integerValue)
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
    
    func NoInternetCheck(error: AnyObject) {
        utilities.hideProgressHud()
        print(error.code, terminator: "")
        if error.code == Variables.Status.Error.NoInternet || error.code == Variables.Status.Error.NoInternet1  {
            let alert = UIAlertView(title: NSLocalizedString("Внимание", comment: "Warning"), message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    // API VERSION 2
    func getVehiclesBy(source: String, destination: String, duedate: String, passCount: String) {
        let VehiclesURL = FindVehicleURL + source + "/" + destination + "/" + duedate + "/" + passCount
        let encodedURL = VehiclesURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        Alamofire.request(.GET, encodedURL!, encoding: .JSON).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    print(responseValue)
                    let driverList = Mapper<DriverQueue>().mapArray(responseValue)
                    self.notificationCenter.postNotificationName(Variables.Notifications.SearchDataReceived, object: driverList)
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
    
    func bookSeatInVehicle(userId: Int, dqId: Int, count: Int, remarks: String = "") {
        
        let params: [String : AnyObject] = [
            "userid": userId,
            "dqid": dqId,
            "count": count,
            "remarks": remarks
        ]
        
        Alamofire.request(.POST, BookSeatInVehicleURL, parameters: params, encoding: .JSON).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    self.notificationCenter.postNotificationName(Variables.Notifications.BookedSeatInVehicle, object: responseValue)
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
    
    func getUserReservations(userId: Int) {

        let orderCancelStatus = 4
        Alamofire.request(.GET, GetUserReservationsURL + userId.description, encoding: .JSON).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    print(responseValue)
                    let userBookings = Mapper<ClientBooking>().mapArray(responseValue)
                    print(userBookings)
                    self.notificationCenter.postNotificationName(Variables.Notifications.UserQueuesAsClientLoaded, object: userBookings!.filter({$0.status != orderCancelStatus}).reverse())
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
    
    func cancelClientReservation(reservationId: Int) {
        print(CancelUserReservationsURL + reservationId.description, terminator: "")
        Alamofire.request(.PUT, CancelUserReservationsURL + reservationId.description).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    self.notificationCenter.postNotificationName(Variables.Notifications.ClientQueueCancelled, object: responseValue.integerValue)
                }
                break
            case .Failure(let error):
                print(error)
                self.NoInternetCheck(error)
                break
            }
        }
    }
}
