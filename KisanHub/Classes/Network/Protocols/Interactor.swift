//
//  APIClient.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

typealias CompletionHandler = (Result<RecordMap>) -> Void

protocol APIClient {
    
    init(baseURL: URL, session: NetworkSession)
    
    func fetchWeatherReportFor(location: Location, on completionHandler: @escaping CompletionHandler)
}

protocol Interactor {
    
    var client: APIClient { get }
    var dataStore: DataStore { get }
    
    init(client: APIClient, dataStore: DataStore)
    
    func fetchWeatherReportFor(location: Location, on completionHandler: @escaping CompletionHandler)
}
