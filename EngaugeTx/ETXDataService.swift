//
//  ETXDataService.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/16/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation


/**
 Service that provides CRUD operations on a model
 */
open class ETXDataService<T: ETXModel> {
    
    var repository: Repository<T>!
    
    init(repository: Repository<T>) {
        self.repository = repository
    }
    
    /**
     Find a model by it's ID
     - parameter id: The ID of the model
     - parameter completion: Callback when the request completes
     - parameter model: The model, if found.
     - parameter err: If an error occurred while finding the item
     */
    public func findById(_ id: String, completion: @escaping (_ model: T?, _ err: ETXError?) -> Void) {
        self.repository.getById(id, completion: completion)
    }
    
    /**
     Find all elements matching the filter
     - parameter filter: Filter to apply to the query
     - parameter completion: Callback when the request completes
     - parameter models: Models of the specified type. Will be ```nil``` if an error occurred
     - parameter err: If an error occurred while getting all items. Will be ```nil``` if get all was successful
     */
    public func findWhere(_ filter: String, completion: @escaping ([T]?, ETXError?) -> Void) {
        
    }
    
    /**
     Find all elements of the specified type
     - parameter completion: Callback when the request completes
     - parameter models: Models of the specified type. Will be ```nil``` if an error occurred
     - parameter err: If an error occurred while getting all items. Will be ```nil``` if get all was successful
    */
    public func findAll(completion: @escaping (_ models: [T]?, _ err: ETXError?) -> Void) {
        self.repository.findWhere(nil, completion: completion)
    }
    
    /**
     Delete a model
     - parameter model: The model to be deleted
     - parameter completion: Callback when the request completes
     - parameter err: If an error occurred while deleting the item
     */
    public func delete(model: T, completion: @escaping (ETXError?) -> Void) {
        guard let modelId = model.id, modelId.isEmpty != true else {
            completion(ETXError())
            return
        }
        self.repository.delete(model: model, completion: completion)
    }
    
    /**
     Save a modely
     - parameter model: The model to be saved
     - parameter completion: Callback when the request completes
     - parameter model: The model, if found.
     - parameter err: If an error occurred while savinga the item
     */
    public func save(model: T, completion: @escaping (T?, ETXError?) -> Void) {
        self.repository.save(model: model, completion: completion)
    }

}