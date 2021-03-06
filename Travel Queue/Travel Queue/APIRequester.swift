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

class APIRequester {
    
    static let BASE_URL = "http://52.33.171.217:8080/"
    private let SALT = "skey"
    private let Register = BASE_URL + "register"
    private let UserActivate = BASE_URL + "user/activate/"
    private let Login = BASE_URL + "login/"
    private let Users = BASE_URL + "user/"
    private let AddToQueue = BASE_URL + "queue/add"
    private let AddToQueueAsDriver = BASE_URL + "dqueue/add"
    private let UserQueuesAsClientById = BASE_URL + "allqueue/"
    private let UserQueuesAsDriverById = BASE_URL + "alldqueue/"
    
    //TRIP
    private let TripConfirm = BASE_URL + "confirmtrip/"
    private let TripReject = BASE_URL + "rejecttrip/"
    private let DriverInfoByClientQueueId = BASE_URL + "getDqueuByCq/"
    private let DriverClientsByQueueId = BASE_URL + "getCqueuByDq/"
    private let DqByCqCompleted = BASE_URL + "getDqueuByCqCompleted/"
    
    
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    
    var user: User?
    
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
                    self.notificationCenter.postNotificationName(Variables.Notifications.Login, object: responseValue.integerValue)
                }
                break
            case .Failure(let error):
                print(error)
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
    
    func postOrderAsClient(clientid: Int, source: String, destination: String, passCount: String, duedate: String, pickup: Int, address: String) {
        let params: [String : AnyObject] = [
            "clientid": clientid,
            "source": source,
            "destination": destination,
            "numberofpassengers": passCount,
            "duedate": duedate,
            "pickup": pickup,
            "address": address
        ]
        Alamofire.request(.POST, AddToQueue, parameters: params, encoding: .JSON).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    self.notificationCenter.postNotificationName(Variables.Notifications.PostOrderClient, object: responseValue.integerValue)
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
                break
            }
        }
    }
    
    func getUserQueuesAsClientById(id: Int) {
        Alamofire.request(.GET, UserQueuesAsClientById + id.description).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {            
                    let queues = Mapper<Queue>().mapArray(responseValue)
                    self.notificationCenter.postNotificationName(Variables.Notifications.UserQueuesAsClientLoaded, object: queues)
                }
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }
    
    func getUserQueuesAsDriverById(id: Int) {
        Alamofire.request(.GET, UserQueuesAsDriverById + id.description).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                if let responseValue = response.result.value {
                    let queues = Mapper<DriverQueue>().mapArray(responseValue)
                    self.notificationCenter.postNotificationName(Variables.Notifications.UserQueuesAsDriverLoaded, object: queues)
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
                break
            }
        }
    }
    
    func confirmDriver(cqid: Int, dqid: Int) {
        print(TripConfirm + cqid.description + "/" + dqid.description)
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
                break
            }
        }
    }
    
    
    /*
    public JSONObject Trip_Reject(long QID, long DQID, String reason, String apiUrl) {
    HttpClient httpClient = getHttpClient();
    JSONObject json = new JSONObject();
    
    System.out.println("New request came to " + apiUrl);
    
    try {
    HttpPut request = new HttpPut(url + apiUrl + QID + "/" + DQID + "/" + reason);
    
    HttpResponse response = httpClient.execute(request);
    json = parseResponseData(response);
    
    } catch (IOException e) {
    json = null;
    // TODO Auto-generated catch block
    } catch (Exception e) {
    e.printStackTrace();
    e.getMessage();
    json = null;
    }
    return json;
    }
    */
    
    
//    Alamofire.request(.POST, "https://httpbin.org/post", parameters: parameters)
    // HTTP body: foo=bar&baz[]=a&baz[]=1&qux[x]=1&qux[y]=2&qux[z]=3
    
    /*
    ////REGISTRATION AND AUTHENTICATION
    
    public static final String Register = "/register"; //post json
    public static final String UnRegister = "/unregister/{id}"; //put
    
    public static final String LOGIN_AUTH = "login/";
    
    public static final String GET_USER_INFO = "user/";
    public static final String CHANGE_USER_PASSWORD = "change_password/";//userpwd/{oldpwd}/{newpwd}
    public static final String RESET_PWD = "/reset/{user}";
    public static final String D_USER_ACTIVATE = "/driver/activate/{user}/{sc_code}";
    
    //TRIP
    public static final String TripConfirm = "confirmtrip/";
    public static final String TripReject = "rejecttrip/";
    public static final String DqByCq = "getDqueuByCq/";
    
    ////ADDING TO QUEUE FOR CLIENTS
    public static final String ADD_TO_QUEUE = "/queue/add";
    public static final String GET_QUEUE_ONE = "queue/";
    public static final String GET_CLIENT_QUEUE = "allqueue/";//{clientid}";
    ;
    
    ////ADDING TO QUEUE FOR DRIVERS
    public static final String ADD_TO_DQUEUE = "/dqueue/add";
    
    // BALANCE AND RECHARGE
    public static final String TOPUP = "/payment/{ps_id}/{pwd}/{id}/{amt}";
    public static final String CHECK_BALANCE = "/balance/{user}";
    public static final String CANCEL_DQUEUE = "/dcancel/";//PUT
    public static final String CANCEL_CQUEUE = "ccancel/"; //PUT
    
    //
    public static final String UPDATE_DQUEUE = "/dqupdate/"; //PUT
    public static final String UPDATE_CQUEUE = "/cqupdate/"; //PUT
    
    */
}
