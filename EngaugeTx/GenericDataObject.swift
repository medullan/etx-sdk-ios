//
//  GenericDataObject.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/14/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Use Generic Data Objects to store data that is unique to your application
 
 ```
 class DoctorVisit: ETXGenericDataObject {
    var visitDate: Date?
 
    override func mapping(map: Map) {
        super.mapping(map: map)
        visitDate <- (map["visitDate"], DateTransform())
    }
 }
 
 class DoctorVisitService: ETXGenericDataService<DoctorVisit> {
    // Do some logic
 }
 
 let doctorVisitSvc = DoctorVisitService()
 doctorVisitSvc.findAll {
    (doctorVisits, err) in
    guard let doctorVisits = doctorVisits else {
        // do err handling
        return
    }
 
    print(doctorVisits)
 }
 
 ```
 
 */
open class ETXGenericDataObject: ETXAggregatableModel, ETXPersistentGenericObject {
    
    private var _className: String?
    private  var className: String {
        get {
            return getModelName()
        }
        set {
            _className = newValue
        }
    }
    
    /**
     When the name of the model needs to differ from the class name, it can be
     configured by overriding and populating this property
     */
    open class var customModelName: String? {
        return nil
    }
    
    /**
     Create an instance of GenericData Object
     */
    required public init() {
        super.init()
    }
    
    /**
     Create an instance from a Map
     - parameter map: The Map object
     */
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override init(owner: ETXUser) {
        super.init(owner: owner)
    }
    
    /**
     Describes how the object should be desearialized
     - parameter map: The data as a Map
     */
    override open func mapping(map: Map) {
        super.mapping(map: map)
        className <- map["className"]
    }
    
    override public func getDataSvc<M: ETXGenericDataObject, T: QueryablePersistenceService>(_ forModel: M) -> T {
        let genericDataObjectRepository = ETXGenericDataObjectRepository<M>(className: (forModel as ETXGenericDataObject).modelName)
        let defaultDataSvc = ETXGenericDataService<M>(repository: genericDataObjectRepository)
        return defaultDataSvc as! T
    }
}

/**
 Provides persistence functionalities for a generic object
 */
public protocol ETXPersistentGenericObject {
    typealias ModelType = Self
    var modelName: String { get }
}

extension ETXPersistentGenericObject where Self: ETXGenericDataObject {
    
    typealias RepositoryType = ETXGenericDataObjectRepository<Self>
    typealias DataServiceType = ETXGenericDataService<Self>
    
    internal func getModelName() -> String {
        var s: String
        if let customModelName = Self.customModelName {
            s = customModelName
        } else {
            s = String(describing: (Mirror(reflecting: self)).subjectType)
        }
        return s
    }
    
    /**
     The name of the model as persisted on the platform
    */
    public var modelName: String {
        if let customModelName = Self.customModelName {
            return customModelName
        }
        // Get the name of the class without the project name prefix
        return String(describing: (Mirror(reflecting: self)).subjectType)
    }
}
