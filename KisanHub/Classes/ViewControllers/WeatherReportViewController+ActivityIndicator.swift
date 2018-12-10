//
//  WeatherReportViewController+ActivityIndicator.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 10/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

// MARK: - Activity Indicator
extension WeatherReportViewController {
    
    func showActivity(withTitle title: String?, andMessage message: String?) {
        ActivityIndicatorProvider.shared.showActivity(onView: self.view, withTitle: title, andMessage: message)
    }
    
    func hideActivity() {
        ActivityIndicatorProvider.shared.hideActivity()
    }
}
