//
//  Record.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

/// Represents individual record information for verious metrics e.g. Tmax/Tmin/Rainfall
struct Record: Codable, Equatable {
    
    /// Metric value
    let value: Double
    
    /// Year
    let year: Int
    
    /// Month
    let month: Int
}
