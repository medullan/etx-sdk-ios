//
//  UserService.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/2/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation

/**
 Provides authentication to the EnguageTx Platform
 */
open class ETXUserService<T: ETXUser> {
    
    private let KEY_ACCESS_TOKEN = "accessToken"
    
    let userRepository: UserRepository<T>
    
    /**
     Create an instance of ETXUserService
     */
    public init() {
        self.userRepository = UserRepository()
    }
    
    /** Login with username.
     - parameter username: The user's username
     - parameter password: The user's password
     - parameter rememberMe: Allows for an extended user session
     - parameter completion: Callback when the request completes
     - parameter object: The TX object
     - parameter err: The error object
     */
    public func loginUserWithUsername(_ username: String, password: String, rememberMe: Bool, completion: @escaping (_ user: T?, _ err: ETXError?) -> Void) {
        
        self.userRepository.loginWithUsername(username, password: password, rememberMe: rememberMe, done: completion)
    }
    
    /**
     Login with email address.
     - parameter email: The user's email address
     - parameter password: The user's password
     - parameter rememberMe: Allows for an extended user session
     - parameter completion: Callback when the request completes
     - parameter object: The TX object
     - parameter err: The error object
     */
    public func loginUserWithEmail(_ email: String, password: String, rememberMe: Bool, completion: @escaping (_ object: T?, _ err: ETXError?) -> Void) {
        self.userRepository.loginWithEmail(email, password: password, rememberMe: rememberMe, done: completion)
    }
    
    
    /**
     Ends the session for the current user
     - parameter completion: Callback when the request completes
     - parameter err: The error object. Will be `nil` if the request was successful
     */
    public func logout(completion: @escaping (_ err: ETXError?)->Void) {
        self.userRepository.logout(completion: completion)
    }
    
    /**
     Get the currently logged in user
     - parameter completion: Callback when the request completes
     */
    public func getCurrentUser(completion:@escaping (T?)->Void) {
        if let userId = self.userRepository.getCurrentUserId() {
            self.userRepository.getById(userId) {
                (user: T?, err: ETXError?) in
                completion(user)
            }
        } else {
            completion(nil)
        }
        
    }
    
    /**
     Create an application user. Only the user's ID will be available on successful registration.
     You can create your own user object by extending the the ```ETXUser``` model
     e.g.
     
     ```
     class Caregiver: ETXUser {
        var badgeId: String = ""
     
        // How your object should map to JSON and vice versa
        override func mapping(map: Map) {
            super.mapping(map: map)
            badgeId <- map["badgeId"]
        }
     }
     
     let userSvc = ETXUserService<Caregiver>()
     let caregiver: Caregiver = Caregiver(..)
     caregiver.badgeId = "FE200"
     userSvc.createUser(testUser) {
        (...) in
        // code
     }
     
     ```
     
     Mapping to and from JSON is leveraged using
     [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
     See [the documentation](https://github.com/Hearst-DD/ObjectMapper#the-basics)
     on best practices on how to map your fields.
     
     - parameter user: The user to be created
     - parameter completion: Callback when the request completes. Supplies the ```ETXUser``` object and an ```ETXError``` object
     - parameter user: The registered user. Only the user ID is accessible until the user confirms their email address. This will be ```nil``` if registration failed
     - parameter err: Error containing details as to the registration process failed. This will be ```nil``` if registration was successful. Details about the error can be found in the ```details``` property and will contain a Dictionary of validation errors.
     */
    public func createUser(_ user: T, completion: @escaping (_ user: T?, _ err: ETXRegistrationError?)->Void) {
        self.userRepository.deleteCurrentUser()
        self.userRepository.save(model: user){
            (user, err) in
            if let err = err, let rawJson = err.rawJson {
                print("User creation failed: \(rawJson)")
                completion(user, ETXRegistrationError(JSON: rawJson))
            } else {
                completion(user, nil)
            }
        }
    }
    
    /**
     Sends the user an email to begin the password reset flow
     
     - parameter emailAddress: The user's email address
     - parameter completion: Callback when the request completes.
     - parameter err: An error object describing what went wrong. Will be ```nil``` if the request was successful

    */
    public func initiatePasswordResetWithEmail(_ emailAddress: String, completion: @escaping (_ err: ETXError?)->Void) {
        self.userRepository.initiatePasswordReset(emailAddress: emailAddress, completion: completion)
    }
    
    func changePassword(_ newPassword: String, currentPassword: String, currentUser: T, completion: @escaping (_ err: ETXError?)->Void) {
        if newPassword == currentPassword {
            completion(nil)
        } else {
            self.userRepository.changePassword(
                PasswordUpdateCredentials(currentPassword: currentPassword, newPassword: newPassword),
                userId: currentUser.id!, completion: completion)
        }
    }
    
    func changeEmailAddress(_ newEmailAddress: String, currentPassword: String, currentUser: T, completion: @escaping (_ err: ETXError?)->Void) {
        if newEmailAddress == currentUser.email {
            completion(nil)
        } else {
            self.userRepository.changeEmailAddress(EmailUpdateCredentials(newEmailAddress: newEmailAddress, currentPassword: currentPassword), userId: currentUser.id!, completion: completion)
        }
    }
    
}
