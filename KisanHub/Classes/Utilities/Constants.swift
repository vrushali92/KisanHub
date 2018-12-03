//
//  Constants.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 01/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

enum Location: String, CaseIterable {
    case UK
    case England
    case Scotland
    case Wales
    
    var value: String {
        switch self {
        case .UK:
            return "UK"
        case .England:
            return "England"
        case .Scotland:
            return "Scotland"
        case .Wales:
            return "Wales"
        }
    }
}

extension String {
    
    func locationForString() -> Location {
        switch self {
        case Location.UK.rawValue:
            return Location.UK
        case Location.England.rawValue:
            return Location.England
        case Location.Scotland.rawValue:
            return Location.Scotland
        case Location.Wales.rawValue:
            return Location.Wales
        default:
            return Location.UK
        }
    }
}

enum Month: Int, Decodable {
    
    case Jan = 1
    case Feb
    case March
    case April
    case May
    case June
    case July
    case Aug
    case Sept
    case Oct
    case Nov
    case Dec
}

enum Metrics: String, CaseIterable {
    
    case MaxTemperature = "Tmax"
    case MinTemperature = "Tmin"
    case Rainfall
}
