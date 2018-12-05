//
//  APIClient.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

protocol Interactor {
    
    typealias CompletionHandler = (ResultMap) -> Void
    
    init(baseURL: URL, session: NetworkSession)
    
    func fetchWeatherReportFor(location: Location, on completionHandler: @escaping CompletionHandler)
}
