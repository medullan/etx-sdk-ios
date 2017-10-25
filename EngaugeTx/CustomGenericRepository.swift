//
//  CustomGenericRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/23/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta

open class ETXCustomGenericObjectRepository<M:ETXGenericDataObject>: ETXGenericDataObjectRepository<M>, CustomizableRepository {
    
    public func provideInstance<T>(resourcePath: String) -> Repository<T>? where T : ETXModel {
        return nil
    }

    
    required public init(resourcePath: String) {
     super.init(resourcePath: resourcePath)
    }

    public var httpPath: String!

    
    public override func beforeResourceRequest(_ resource: Resource, completion: @escaping () -> Void) {
        self.httpPath = resource.url.absoluteString
    }
    
}
