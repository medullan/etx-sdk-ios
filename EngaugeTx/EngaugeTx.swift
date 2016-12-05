//
//  EngaugeTx.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 11/28/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Alamofire

/**
 Protocol to be extended by the app delegate to be able to bootstrap your
 application with EngaugeTx
 */
public protocol EngaugeTxAppDelegate {
    
    /**
     
     */
    var engaugeTx: EngaugeTxApplication? { get set }
    
}

/**
 Representation of you application in the EngaugeTx platform
 */
public class EngaugeTxApplication {
    var appId: String
    var clientKey: String
    var baseUrl: String
    
    static let KEY_APP_ID: String = "appId"
    static let KEY_CLIENT_KEY: String = "clientKey"
    static let KEY_BASE_URL: String = "baseUrl"
    static let CONFIG_FILENAME = "EngaugeTx"
    static let CONFIG_FILE_TYPE = "plist"
    static let DEFAULT_BASE_URL = "https://api.eu1.engaugetx.com/v1"
    
    /**
     
     */
    public init(appId: String, clientKey: String, baseUrl: String) {
        self.baseUrl = baseUrl
        self.appId = appId
        self.clientKey = clientKey
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders["app-id"] = appId
        defaultHeaders["client-key"] = clientKey
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        
        let _ = Alamofire.SessionManager(configuration: configuration)
    }
    
    /**
     Sets up an EngaugeTx Application with your credentials
     
     - parameter appId: The application's ID
     - parameter clientKey: The application's client Key
     */
    public convenience init(appId: String, clientKey: String) {
        self.init(appId: appId, clientKey: clientKey,
                  baseUrl: EngaugeTxApplication.DEFAULT_BASE_URL)
    }
    
    /// Sets up an EngaugeTx Application with credentials stored in your Plist file
    public convenience init() {
        if let appId = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_APP_ID),
            let clientKey = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_CLIENT_KEY),
            let baseUrl = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_BASE_URL) {
            self.init(appId: appId, clientKey: clientKey, baseUrl: baseUrl)
        } else {
            self.init(appId: "", clientKey: "")
        }
    }
    
    static func getValueForKey(key: String) -> String? {
        return getValueForKey(key: key, plistFileName: CONFIG_FILENAME)
    }
    
    static func getValueForKey(key: String, plistFileName: String) -> String? {
        var value: String?
        guard let path = Bundle.main.path(forResource: plistFileName, ofType: CONFIG_FILE_TYPE) else {
            print("The file was not found")
            return nil
        }
        print("The path \(path)")
        if let keys = NSDictionary(contentsOfFile: path), let keyValue = keys.value(forKey: key) {
            value = keyValue as? String
        }
        return value
    }
    
    func testCall(don: @escaping (String) ->Void) {
        let headers: HTTPHeaders = [
            "Authorization": "thqvTvYIqTPFCIYmTKz2YM397vYLVlTHwrWVPS2GsJTvA4DhVxYr8DJEJewwIXVt",
            "Accept": "application/json"
        ]
        Alamofire.request( self.baseUrl + "/users/57f3d6999ba8b300cfd604ed", headers: headers).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
            don("Done")
        }
    }
}
