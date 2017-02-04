//
//  DeviceTokenTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 2/4/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper
class DeviceTokenTests: AuthenticatedTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testSaveDeviceTokenWhenTheTokenIsUnique() {
        let uniqueToken: String = "\((Date()).timeIntervalSince1970)"
        let deviceToken = ETXDeviceToken(token: uniqueToken)
        let tokenSaveExpectation = expectation(description: "Successful token save")
        deviceToken.save {
            (err) in
            XCTAssertNil(err, "Token save should not fail");
            tokenSaveExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("Login expectation timeout \(err)")
        }
    }
    
    func testSaveDeviceTokenWhenTheTokenAlreadyExist() {
        let uniqueToken: String = "\((Date()).timeIntervalSince1970)"
        let deviceToken = ETXDeviceToken(token: uniqueToken)
        let tokenSaveExpectation = expectation(description: "Successful token save")
        deviceToken.save {
            (err) in
            XCTAssertNil(err, "Token save should not fail");
            let duplicateToken = ETXDeviceToken(token: uniqueToken)
            print(deviceToken.id)
            duplicateToken.save {
                (err) in
                XCTAssertNotNil(err, "Duplicate token should result in an error")
//                XCTAssertNotNil(err!.statusCode)
//                XCTAssertEqual(400, err!.statusCode)
                tokenSaveExpectation.fulfill()
            }
            
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("Login expectation timeout \(err)")
        }
    }

    
    
}
