//
//  Record.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

/// Model class to store record
struct Record: Codable {
    
    /// Value for Metric: Tmax/Tmin/Rainfall
    let value: Double
    
    /// Year
    let year: Int
    
    /// Month
    let month: Int
}
