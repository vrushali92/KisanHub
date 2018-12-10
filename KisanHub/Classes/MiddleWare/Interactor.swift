//
//  Interactor.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 09/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

/// Provides APIClient and Datastore to retrive data accordingly
protocol Interactor {
    
    /// APIClient instance
    var client: APIClient { get }
    
    /// DataStore instance
    var dataStore: DataStore { get }
    
    /// Initializes with APIClient and DataStore
    ///
    /// - Parameters:
    ///   - client: APIClient instance
    ///   - dataStore: DataStore instance
    init(client: APIClient, dataStore: DataStore)
    
    /// First Fetches report either from Datastore if not available then from Webservice
    ///
    /// - Parameters:
    ///   - location: selected location
    ///   - completionHandler: CompletionHandler
    func fetchWeatherReportFor(location: Location, on completionHandler: @escaping CompletionHandler)
}
