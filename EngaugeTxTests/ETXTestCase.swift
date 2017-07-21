//
//  ETXTestCase.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/16/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx

class ETXTestCase: XCTestCase {
    var app: EngaugeTxApplication!
    let TIMEOUT_DEFAULT: TimeInterval = 10
    
    let defaultTestUser:ETXUser = ETXUser(email: "mjoseph+1500676262595@medullan.com", username: "mjoseph+1500676262595", password: "P@ssw0rd")
    var testUserUnverified:ETXUser = ETXUser(email: "mjoseph+unverified_1500676262595@medullan.com", username: "mjoseph+unverified_1500676262595", password: "P@ssw0rd")
    var caregiverUser = ETXUser(email: "mjoseph+caregiver_1500676262595@medullan.com", username: "mjoseph+caregiver_1500676262595", password: "P@ssw0rd")
    var patientUser = ETXUser(email: "mjoseph+patient_1500676262595@medullan.com", username: "mjoseph+patient_1500676262595", password: "P@ssw0rd")
    
    var extendedUser = ETXUser(email: "mjoseph+extendedUser_1500676262595@medullan.com", username: "mjoseph+extendedUser_1500676262595@medullan.com", password: "P@ssw0rd")
    
    
    let stagingApp = EngaugeTxApplication(
        appId: "e8b836cd6d20f3431e0fbcb54196360b",
        clientKey: "7c2759273aaf770093f92e0accca965255fac0d1",
        baseUrl: "https://api.staging.us1.engaugetx.com/v1"
    )
    
//    let localApp = EngaugeTxApplication(
//        appId: "e8b836cd6d20f3431e0fbcb54196360b",
//        clientKey: "7c2759273aaf770093f92e0accca965255fac0d1",
//        baseUrl: "http://localhost:3000/v1"
//    )
    
    //    let biApp = EngaugeTxApplication(
    //        appId: "e8b836cd6d20f3431e0fbcb54196360b",
    //        clientKey: "7c2759273aaf770093f92e0accca965255fac0d1",
    //        baseUrl: "https://api.us1.engaugetx.com/v1"
    //    )
    
    override func setUp() {
        super.setUp()
//        self.app = EngaugeTxApplication(
//            appId: "e8b836cd6d20f3431e0fbcb54196360b",
//            clientKey: "7c2759273aaf770093f92e0accca965255fac0d1",
//            baseUrl: "https://api.us1.engaugetx.com/v1"
//        )
        self.app = EngaugeTxApplication(
            appId: "743f932a6fecf5cc30730c2385d6e7c7",
            clientKey: "b7fd395de3739fd6bc36d459ac47ec5e642a0331",
            baseUrl: "https://api.staging.us1.engaugetx.com/v1"
        )
    }
    
    
    override func tearDown() {
        super.tearDown()
        self.app = nil
    }
    
    func getUniqueId() -> String {
        return "tx_\(NSUUID().uuidString.lowercased().replacingOccurrences(of: "-", with: ""))"
    }
    
    func testGetUniqueId() {
        let uniqueId = getUniqueId()
        XCTAssertTrue(uniqueId.characters.count>0)
    }
}
