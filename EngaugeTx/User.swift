//
//  User.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/2/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Represents a user of an application on the platform
 */
open class ETXUser: ETXPersistedModel {
    
    // TODO: Ensure that the type is Generic
    private var _userSvc: ETXUserService<ETXUser>?
    var userService: ETXUserService<ETXUser> {
        if _userSvc == nil {
            _userSvc = ETXUserService()
        }
        return _userSvc!
    }
    
    /**
     The user's first name
     */
    public var firstName: String?
    
    /**
     The user's last name
     */
    public var lastName: String?
    
    /**
     The username of the user
     */
    public var username: String
    
    /**
     The user's email address
     */
    public var email: String
    
    /**
     The user's Password
     */
    public var password: String?
    
    /**
     The User's preferred locale
    */
    public var locale: String?
    
    /**
     Create a new instance
     - parameter email: The user's email address
     - parameter username: The username for the user
     - parameter password: The user's password
    */
    public init(email: String, username: String, password: String) {
        self.email = email
        self.username = username
        self.password = password
        super.init()
    }
    
    public init(user: ETXAffiliatedUser) {
        self.email = ""
        self.username = ""
        super.init()
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.id = user.id
        
    }
    
    public required init() {
        self.email = ""
        self.username = ""
        super.init()
    }
    
    /**
     Creates a instance of ETXUser
     */
    required public init?(map: Map) {
        self.email = ""
        self.username = ""
        do {
            try self.username = map.value("username")
            try self.email = map.value("email")
        }
        catch {
            EngaugeTxLog.error("Err occured while mapping to an ETXUser", context: error)
        }

        super.init(map: map)
    }
    
    /**
     Creates a instance of ETXUser from map
     */
    open override func mapping(map: Map) {
        super.mapping(map: map)
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        username <- map["username"]
        email <- map["email"]
        password <- map["password"]
        locale <- map["locale"]
    }
    
    /**
     Update the user's password. A notification email will be sent to the 
     current email address
     - parameter newPassword: The new password to change to
     - parameter currentPassword: The current password
     - parameter completion: Callback when the request completes
     - parameter err: The error if the request fails
    */
    public func updatePassword(_ newPassword: String, currentPassword: String, completion: @escaping (_ err: ETXError?)->Void) {
        self.userService.changePassword(newPassword, currentPassword: currentPassword, currentUser: self, completion: completion)
    }
    
    /**
     Update the user's email address. An email will be sent to the current email 
     address notifying that the request was made, and another to new address for
     confirmation. The new address will only be applied to the account, after
     the new email is confirmed
     - parameter newEmailAddress: The new email address to change to
     - parameter currentPassword: The current password
     - parameter completion: Callback when the request completes
     - parameter err: The error if the request fails
     */
    public func updateEmailAddress(_ newEmailAddress: String, currentPassword: String, completion: @escaping (_ err: ETXError?)->Void) {
        self.userService.changeEmailAddress(newEmailAddress, currentPassword: currentPassword, currentUser: self, completion: completion)
    }
    
    /**
     The sevice class responsible for making API calls on behalf of the model
    **/
    public override func getDataSvc<M: ETXUser, T: QueryablePersistenceService>(_ forModel: M) -> T {
        let userRepository = UserRepository<M>(resourcePath: "/users")
        let defaultDataSvc = ETXUserService<M>(repository: userRepository)
        return defaultDataSvc as! T
    }
    
    public func delete(hardDelete: Bool, completion: @escaping (ETXError?) -> Void) {
        self.userService.delete(model: self, hardDelete: hardDelete, completion: completion)
    }
}
