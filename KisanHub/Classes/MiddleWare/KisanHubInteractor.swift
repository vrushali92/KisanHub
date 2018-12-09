//
//  KisanHubAPIClient.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

final class KisanHubInteractor: Interactor {
    
    let client: APIClient
    
    let dataStore: DataStore
    
    init(client: APIClient = KisanHubAPIClient(), dataStore: DataStore = KisanHubDataStore()) {
        self.client = client
        self.dataStore = dataStore
    }

    func fetchWeatherReportFor(location: Location, on completionHandler: @escaping CompletionHandler) {
        
        if let cached = self.dataStore.retrieve(ForLocation: location) {
            completionHandler(.success(cached))
            return
        }
        self.client.fetchWeatherReportFor(location: location) {[dataStore = self.dataStore] result in
            switch result {
            case .success(let records):
                completionHandler(.success(records))
                dataStore.save(data: records, forLocation: location, with: nil)
            case .failed(let error):
                completionHandler(.failed(error))
            }
        }
    }
}

final class KisanHubAPIClient: APIClient {
    private let url: URL
    private let session: NetworkSession
    
    init(baseURL: URL = NetworkConstants.baseURL, session: NetworkSession = URLSession(configuration: .default)) {
        self.url = baseURL
        self.session = session
    }
    
    func fetchWeatherReportFor(location: Location, on completionHandler: @escaping CompletionHandler) {
        
        let requests = Metrics.allCases.reduce(into: [Metrics: WeatherReportService]()) { map, metric in
            map[metric] = WeatherReportService(baseURL: self.url, location: location, matric: metric)
        }
        
        requests.execute(withSession: self.session, completionHandler: completionHandler)
    }
}
