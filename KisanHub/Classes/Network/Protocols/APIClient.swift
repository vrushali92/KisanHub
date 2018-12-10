//
//  APIClient.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

typealias CompletionHandler = (Result<RecordMap>) -> Void

/// Provides APIClient to fetch weather report
protocol APIClient {
    
    /// Initiates with baseURL and network session
    ///
    /// - Parameters:
    ///   - baseURL: URL
    ///   - session: NetworkSession
    init(baseURL: URL, session: NetworkSession)
    
    /// Fetch Weather Report for particular location
    ///
    /// - Parameters:
    ///   - location: Location
    ///   - completionHandler: CompletionHandler
    func fetchWeatherReportFor(location: Location, on completionHandler: @escaping CompletionHandler)
}
