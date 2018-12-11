//
//  KisanHubInteractorTests.swift
//  KisanHubTests
//
//  Created by Vrushali Kulkarni on 10/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import XCTest
@testable import KisanHub

final class KisanHubInteractorTests: XCTestCase {
    
    var mock: NetworkSessionMock!
    override func setUp() {
        self.mock = NetworkSessionMock()
    }
    
    override func tearDown() {
        self.mock = nil
    }
    
    func testWhenThereIsNoStoredData() {
        
        let client = KisanHubAPIClientMock()
        let locationToTest = Location.unitedKingdom
        let dummyResponse: RecordMap = [.rainfall: [Record(value: 111.4, year: 1910, month: 1)]]
        client.set(response: dummyResponse, forLocation: locationToTest)
        
        let dataStore = DatastoreMock()
        let interactor = KisanHubInteractor(client: client, dataStore: dataStore)
        
        XCTAssertFalse(dataStore.hasStoredResponse(forLocation: locationToTest))
        
        let expectation = self.expectation(description: "Client should succeed")
        
        interactor.fetchWeatherReportFor(location: locationToTest) {_ in
            expectation.fulfill()
            XCTAssertEqual(locationToTest, client.lastExecutedLocation)
        }
        XCTAssertTrue(dataStore.hasStoredResponse(forLocation: locationToTest))
        XCTAssertEqual(dataStore.retrieve(ForLocation: locationToTest), dummyResponse)
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testWhenThereIsStoredData() {
        
        let dataStore = DatastoreMock()
        let client = KisanHubAPIClientMock()
        let interactor = KisanHubInteractor(client: client, dataStore: dataStore)
        
        let locationToTest = Location.unitedKingdom
        let dummyResponse: RecordMap = [.rainfall: [Record(value: 111.4, year: 1910, month: 1)]]
        
        let expectation = self.expectation(description: "Datastore should succeed")
        
        dataStore.save(data: dummyResponse, forLocation: locationToTest) { _ in}
        
        interactor.fetchWeatherReportFor(location: locationToTest) { _ in
            expectation.fulfill()
        }
        
        XCTAssertEqual(dataStore.retrieve(ForLocation: locationToTest), dummyResponse)
        XCTAssertNil(client.lastExecutedLocation)
        self.wait(for: [expectation], timeout: 1)
    }
}
