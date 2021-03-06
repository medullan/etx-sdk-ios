//
//  Steps.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/10/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Represents the Steps activity
 */
open class ETXSteps: ETXMeasurement {
    
    /**
     The number of steps taken
     */
    public var steps: Int?
    
    /**
     The number of calories burned during the activity
     */
    public var calories: Float?
    
    /**
     The length of time (in minutes) taken to achieve the stepCount
     */
    public var duration: Int?
    
    override open class var trendResultKey: String {
        return "Steps"
    }
    
    override class var modelResourcePath: String {
        return "/Steps"
    }
    
    public override func getDataSvc<M: ETXSteps, T: QueryablePersistenceService>(_ forModel: M) -> T {
        let repository = ETXShareableModelRespository<M>(resourcePath: "/steps")
        let defaultDataSvc = ETXShareableModelDataService<M>(repository: repository)
        return defaultDataSvc as! T
    }
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        steps <- map["steps"]
        calories <- map["calories"]
        duration <- map["duration"]
    }
}
