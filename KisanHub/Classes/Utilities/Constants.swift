//
//  Constants.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 01/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

enum Location: String, CaseIterable, Codable {
    case UK
    case england
    case scotland
    case wales
    
    var value: String {
        switch self {
        case .UK:
            return "UK"
        case .england:
            return "England"
        case .scotland:
            return "Scotland"
        case .wales:
            return "Wales"
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }
}

extension Location {
    
    static func location(fromString string: String) -> Location {
        switch string {
        case Location.UK.rawValue:
            return .UK
        case Location.england.rawValue:
            return .england
        case Location.scotland.rawValue:
            return .scotland
        case Location.wales.rawValue:
            return .wales
        default:
            return .UK
        }
    }
}

enum Month: Int, Decodable {
    
    case jan = 1
    case feb
    case march
    case april
    case may
    case june
    case july
    case aug
    case sept
    case oct
    case nov
    case dec
}

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
