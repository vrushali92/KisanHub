//
//  WeatherReportService.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

struct WeatherReportService: DecodableDataService {
    
    private static let jsonExtension =  ".json"
    typealias Response = [Record]
    
    let baseURL: URL
    let location: Location
    let matric: Metrics
    
    init(baseURL: URL, location: Location, matric: Metrics) {
        self.baseURL = baseURL
        self.location = location
        self.matric = matric
    }
    
    func asURLRequest() throws -> URLRequest {
    
        return URLRequest(url: self.baseURL.appendingPathComponent(self.pathFragment))
    }
    
    private var pathFragment: String {
        return "\(self.matric.rawValue)-" + "\(self.location.rawValue)" + type(of: self).jsonExtension
    }
}
