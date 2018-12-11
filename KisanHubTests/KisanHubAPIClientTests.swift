//
//  KisanHubAPIClientTests.swift
//  KisanHubTests
//
//  Created by Vrushali Kulkarni on 10/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import XCTest
@testable import KisanHub
// swiftlint:disable line_length
final class KisanHubAPIClientTests: XCTestCase {
    
    var mock: NetworkSessionMock!
    
    override func setUp() {
        self.mock = NetworkSessionMock()
    }
    
    override func tearDown() {
        self.mock = nil
    }
    
    func testWithExpectedJSON() {
        
        let stubbedData = """
        [{"value":111.4,"year":1910,"month":1},{"value":126.1,"year":1910,"month":2},{"value":49.9,"year":1911,"month":1},{"value":95.3,"year":1911,"month":3},{"value":71.8,"year":2007,"month":5},{"value":70.2,"year":2007,"month":6},{"value":97.1,"year":2009,"month":7},{"value":140.2,"year":2009,"month":8},{"value":27,"year":2010,"month":9},{"value":89.4,"year":2010,"month":10},{"value":128.4,"year":2014,"month":11},{"value":142.2,"year":2014,"month":12}]
"""
        let data = Data(bytes: stubbedData.utf8)
        self.mock.response = .success(data)
        
        let client = KisanHubAPIClient(baseURL: URL(string: "demo.com")!, session: self.mock)
        
        let expectation = self.expectation(description: "Client should succeed")
        
        client.fetchWeatherReportFor(location: .scotland) { response in
            expectation.fulfill()
            XCTAssertNotNil(response)
            XCTAssertEqual(response.value?.count, 3)
            guard let response = response.value else { return }
            let count = response[Metrics.maxTemperature]?.filter({ $0.year == 1910 }).count
            XCTAssertEqual(count, 2)
        }
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testWithEmptyJSON() {
        
        self.mock.response = .success(Data())
        
        let client = KisanHubAPIClient(baseURL: URL(string: "demo.com")!, session: self.mock)
        let expectation = self.expectation(description: "Client should fail")
        client.fetchWeatherReportFor(location: .england) { response in
            expectation.fulfill()
            XCTAssertNotNil(response.failed)
            XCTAssertNil(response.value)
        }
        self.wait(for: [expectation], timeout: 1)
    }
}
