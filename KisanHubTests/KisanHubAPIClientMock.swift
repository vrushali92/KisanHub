//
//  KisanHubAPIClientMock.swift
//  KisanHubTests
//
//  Created by Vrushali Kulkarni on 11/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation
@testable import KisanHub

final class KisanHubAPIClientMock: APIClient {
    
    private var responseMap = [Location: [Metrics: [Record]]]()
    private(set) var lastExecutedLocation: Location?
    
    init(baseURL: URL = URL(string: "mock.com")!, session: NetworkSession = NetworkSessionMock()) {
    }
    
    func set(response: [Metrics: [Record]], forLocation location: Location) {
        self.responseMap[location] = response
    }
    
    func fetchWeatherReportFor(location: Location, on completionHandler: @escaping CompletionHandler) {
        self.lastExecutedLocation = location
        guard let stored = self.responseMap.removeValue(forKey: location) else {
            completionHandler(.failed(NetworkSessionMock.NetworkSessionMockError.responseIsNotSet))
            return
        }
        completionHandler(.success(stored))
    }
}
