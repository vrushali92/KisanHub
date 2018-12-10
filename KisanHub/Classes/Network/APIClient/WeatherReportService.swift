//
//  WeatherReportService.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

/// Provides request
struct WeatherReportService: DecodableDataService {
    
    /// File extension
    private static let jsonExtension =  ".json"
    
    typealias Response = [Record]
    
    /// Base URL
    let baseURL: URL
    
    /// Location
    let location: Location
    
    /// Metric
    let metric: Metrics
    
    /// Initiates with URL, Location, Metrics
    ///
    /// - Parameters:
    ///   - baseURL: URL
    ///   - location: Location
    ///   - matric: Metrics
    init(baseURL: URL, location: Location, matric: Metrics) {
        self.baseURL = baseURL
        self.location = location
        self.metric = matric
    }
    
    /// Returns URLRequest by appending pathFragment to base url
    ///
    /// - Returns: URLRequest
    func asURLRequest() throws -> URLRequest {
    
        return URLRequest(url: self.baseURL.appendingPathComponent(self.pathFragment))
    }
    
    /// Appends Metric, location and extension
    private var pathFragment: String {
        return "\(self.metric.rawValue)-" + "\(self.location.value)" + type(of: self).jsonExtension
    }
}
