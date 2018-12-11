//
//  UIColor+Palette.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 11/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import UIKit

extension UIColor {
    
    enum Marker {
        static let bodyColor = UIColor(named: "marker_body_color")!
        static let textColor = UIColor(named: "marker_text_color")!
    }
    
    enum Metrics {
        static let maxTemperature = UIColor(named: "max_temp")!
        static let minTemperature = UIColor(named: "min_temp")!
        static let rainfall = UIColor(named: "rainfall")!
    }
}
