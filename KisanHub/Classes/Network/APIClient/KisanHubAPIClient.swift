//
//  KisanHubAPIClient.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

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
