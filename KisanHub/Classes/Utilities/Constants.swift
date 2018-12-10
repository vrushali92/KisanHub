//
//  Constants.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 01/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

/// Location
enum Location: String, CaseIterable, Codable {
    
    case unitedKingdom = "UK"
    case england = "England"
    case scotland = "Scotland"
    case wales = "Wales"
    
    var value: String {
        return self.rawValue
    }
    
}

extension Location {
    
    /// Returns location from selected location string
    ///
    /// - Parameter string: string location from selected segment control
    /// - Returns: enum location
    static func location(fromString string: String) -> Location {
        switch string {
        case Location.unitedKingdom.value:
            return .unitedKingdom
        case Location.england.value:
            return .england
        case Location.scotland.value:
            return .scotland
        case Location.wales.value:
            return .wales
        default:
            return .unitedKingdom
        }
    }
}

/// Metrics
///
/// - maxTemperature: Maximum temperature
/// - minTemperature: Minimum temperature
/// - rainfall: Rainfall
enum Metrics: String, CaseIterable, Decodable {
    
    case maxTemperature = "Tmax"
    case minTemperature = "Tmin"
    case rainfall = "Rainfall"
}

extension Metrics: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
