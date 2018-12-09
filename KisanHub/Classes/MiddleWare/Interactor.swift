//
//  Interactor.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 09/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation
protocol Interactor {
    
    var client: APIClient { get }
    var dataStore: DataStore { get }
    
    init(client: APIClient, dataStore: DataStore)
    
    func fetchWeatherReportFor(location: Location, on completionHandler: @escaping CompletionHandler)
}
