//
//  Date.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 2/9/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 * Allows transformation of Date Types to/from JSON
 */
public class ETXDateTransform: TransformType {
    static let SERVER_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.S'Z'"
    static let LOCAL_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.S"
    static let SERVER_DATE_TIMEZOME = "UTC"
    
    public init() { }
    
    /**
     Transforms from its JSON value
     returns: The value from its JSON value
     */
    public func transformFromJSON(_ value: Any?) -> Date? {
        
        guard case let value as String = value else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: ETXDateTransform.SERVER_DATE_TIMEZOME)
        formatter.dateFormat = ETXDateTransform.SERVER_DATE_FORMAT
        guard let date: Date = formatter.date(from: value) else {
            return nil
        }
        
        return date
    }
    
    /**
     Transforms to its JSON value
     returns: The value as a JSON property value
     */
    public func transformToJSON(_ value: Date?) -> String? {
        guard let value = value else {
            return nil
        }
        return value.toTxDateFormat()
    }
}

public extension Date {
    /**
     Get the String representation of the date (in UTC), in the format the platform supports
     returns: The String representation of the date, in the format the platform supports
     */
    public func toTxDateFormat() -> String? {
        return toTxDateFormat(convertToUTC: true)
    }
    
    /**
     Get the String representation of the date, in the format the platform supports
     - parameter convertToUTC: Whether the date should be converted to UTC
     returns: The String representation of the date, in the format the platform supports
     */
    public func toTxDateFormat(convertToUTC: Bool) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ETXDateTransform.LOCAL_DATE_FORMAT
        if convertToUTC == true {
            dateFormatter.dateFormat = ETXDateTransform.SERVER_DATE_FORMAT
            dateFormatter.timeZone = TimeZone(abbreviation: ETXDateTransform.SERVER_DATE_TIMEZOME)
        }
        return dateFormatter.string(from: self)
    }
}

public class ETXDateOnlyTransform: TransformType {
    static let SERVER_DATE_FORMAT = "yyyy-MM-dd"
    
    public init() {}
    
    /**
     Transforms from its JSON value
     returns: The value from its JSON value
     */
    public func transformFromJSON(_ value: Any?) -> Date? {
        
        guard case let value as String = value else {
            return nil
        }
        var date: Date?
        // Try to convert from the Zulu format
        let etxDateTransform = ETXDateTransform()
        if let dateFromZuluTime = etxDateTransform.transformFromJSON(value) {
            date = DateService.setToMidnight(dateFromZuluTime)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = ETXDateOnlyTransform.SERVER_DATE_FORMAT
            date = formatter.date(from: value)
        }
        return date
    }
    
    /**
     Transforms to its JSON value
     returns: The value as a JSON property value
     */
    public func transformToJSON(_ value: Date?) -> String? {
        guard let value = value else {
            return nil
        }
        return DateService.setToMidnight(value).toTxDateFormat()
    }
}

