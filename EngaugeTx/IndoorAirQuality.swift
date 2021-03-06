//
//  IndoorAirQuality.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/10/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Represents the measure of household air quality
 **/
open class ETXIndoorAirQuality: ETXAirQuality {
    /**
     Volatile Organic Compound (VOC)
     */
    public var voc: Int?
    
    /**
     Unit for volatile organic compounds.
     */
    public var vocUnit: String?
    
    /**
     Particulate Matter (PM10)
     */
    public var pm10: Double?
    
    /**
     Unit for pm10
     */
    public var pm10Unit: String?
    
    /**
     Measure of the warmth or coldness of the area.
     */
    public var temp: Double?
    
    /**
     Unit for temperature.
     */
    public var tempUnit: String?
    
    /**
     Measure for the amount of water vapor in the air.
     */
    public var humidity:Double?
    
    /**
     Unit for humidity.
     */
    public var humidityUnit: String?
    
    /**
     Measure of the levels of Carbon dioxide in the air.
     */
    public var co2: Double?
    
    /**
     Unit for Carbon dioxide.
     */
    public var co2Unit: String?
    
    override open class var trendResultKey: String {
        return "IndoorAirQuality"
    }
    
    override class var modelResourcePath: String {
        return "/IndoorAirQuality"
    }
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        voc <- map["voc"]
        vocUnit <- map["vocUnit"]
        pm10 <- map["pm10"]
        pm10Unit <- map["pm10Unit"]
        co2Unit <- map["co2Unit"]
        co2 <- map["co2"]
        temp <- map["temp"]
        tempUnit <- map["tempUnit"]
        humidity <- map["humidity"]
        humidityUnit <- map["humidityUnit"]
    }
    public override func getDataSvc<M: ETXIndoorAirQuality, T: QueryablePersistenceService>(_ forModel: M) -> T {
        let repository = ETXShareableModelRespository<M>(resourcePath: "/IndoorAirQuality")
        let defaultDataSvc = ETXShareableModelDataService<M>(repository: repository)
        return defaultDataSvc as! T
    }
}
