//
//  ETXDataService.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/16/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
public protocol PersistenceService {
    func asQueryable<T: QueryablePersistenceService>() -> T
}

public protocol QueryablePersistenceService {
    associatedtype T : ETXPersistableModel
    func findById(_ id: String, completion: @escaping (_ model: T?, _ err: ETXError?) -> Void)
    func findWhere(_ filter: ETXSearchFilter, completion: @escaping ([T]?, ETXError?) -> Void)
    func findAll(completion: @escaping (_ models: [T]?, _ err: ETXError?) -> Void)
    func delete(model: T, completion: @escaping (ETXError?) -> Void)
    func save(model: T, completion: @escaping (T?, ETXError?) -> Void)
}

/**
 Service that provides CRUD operations for a model
 */
open class ETXDataService<T: ETXPersistedModel>: QueryablePersistenceService, PersistenceService {
    
    public func asQueryable<T>() -> T where T : QueryablePersistenceService {
        return self as! T
    }

    
    public var repository: Repository<T>!
    private var modelType: T.Type = T.self
    
    public init() {
        
    }
    
    required public init(repository: Repository<T>) {
        self.repository = repository
    }
    
    public convenience init(repository: Repository<T>, modelType: T.Type, typeAsString: String) {
        self.init(repository: repository)
        self.modelType = modelType
    }
    
    convenience init(resourcePath: String) {
        self.init(repository: Repository<T>(resourcePath: resourcePath))
    }

    
    /**
     Find a model by it's ID
     - parameter id: The ID of the model
     - parameter completion: Callback when the request completes
     - parameter model: The model, if found.
     - parameter err: If an error occurred while finding the item
     */
    public func findById(_ id: String, completion: @escaping (_ model: T?, _ err: ETXError?) -> Void) {
        self.getRepository().getById(id, completion: completion)
    }
    
    /**
     Find all elements matching the filter
     - parameter filter: Filter to apply to the query
     - parameter completion: Callback when the request completes
     - parameter models: Models of the specified type. Will be ```nil``` if an error occurred
     - parameter err: If an error occurred while getting all items. Will be ```nil``` if get all was successful
     */
    public func findWhere(_ filter: ETXSearchFilter, completion: @escaping ([T]?, ETXError?) -> Void) {
        self.getRepository().findWhere(filter, completion: completion)
    }
    
    /**
     Find all elements of the specified type
     - parameter completion: Callback when the request completes
     - parameter models: Models of the specified type. Will be ```nil``` if an error occurred
     - parameter err: If an error occurred while getting all items. Will be ```nil``` if get all was successful
    */
    public func findAll(completion: @escaping (_ models: [T]?, _ err: ETXError?) -> Void) {
        self.getRepository().findWhere(ETXSearchFilter(), completion: completion)
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
        self.getRepository().delete(model: model, completion: completion)
    }
    
    /**
     Save a model
     - parameter model: The model to be saved
     - parameter completion: Callback when the request completes
     - parameter model: The model, if found.
     - parameter err: If an error occurred while savinga the item
     */
    public func save(model: T, completion: @escaping (T?, ETXError?) -> Void) {
        self.getRepository().save(model: model, completion: completion)
    }
    
    func getRepository() -> Repository<T> {
        if let customDefinedRepoType = self.getCustomRepoType(forModelType: T.self) {
            EngaugeTxLog.debug("A custom repository is defined")
            let c = customDefinedRepoType.init(resourcePath: self.repository.resourcePath) as! CustomizableRepository
            return c.provideInstance(resourcePath: self.repository.resourcePath)!
        }
        return self.repository
    }
    
    private func getCustomRepoType(forModelType: T.Type) -> Repo.Type? {
        let appInstance = EngaugeTxApplication.getInstance()
        var modelTypeAsString: String = String(describing: T.self)
        // Check if there is repository for this specific type
        if let customRepoType = appInstance.customDataRepositories[modelTypeAsString] {
            return customRepoType
        }
        
        let modelInst = T.self.init()
        if modelInst is ETXGenericDataObject {
             modelTypeAsString = String(describing: ETXGenericDataObject.self)
        } else if modelInst is ETXPersistedModel {
            modelTypeAsString = String(describing: ETXPersistedModel.self)
        }
        
        return appInstance.customDataRepositories[modelTypeAsString]
    }
    
    public static func useCustomDataRepository<M: ETXModel, R: CustomizableRepository>(_ repoType: R.Type, forModelType: M.Type) {
        EngaugeTxApplication.addCustomRepository(modelType: forModelType, repositoryType: repoType)
    }
    
    
}
