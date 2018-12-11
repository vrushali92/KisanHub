//
//  NetworkConstants.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

typealias RecordMap = [Metrics: [Record]]

/// Network Constants
enum NetworkConstants {
    
    static let baseURL = URL(string: "https://s3.eu-west-2.amazonaws.com/interview-question-data/metoffice/")!
    static let acceptableStatusCodes = Set(200..<299)
    static let defaultTimeout: TimeInterval = 30
}

/// Type of response error
enum ResponseError: Error {
    case invalidResponse
    case noDataAvailable
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "InvalidResponse"
            
        case .noDataAvailable:
            return "No Data Available"
        }
    }
}
