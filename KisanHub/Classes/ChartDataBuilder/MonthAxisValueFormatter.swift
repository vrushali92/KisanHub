//
//  MonthAxisValueFormatter.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 11/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation
import Charts

final class MonthAxisValueFormatter: IndexAxisValueFormatter {
    private static let dateFormatter = DateFormatter()
    private let months = [1: "Jan", 2: "Feb", 3: "March",
                          4: "April", 5: "May", 6: "June",
                          7: "July", 8: "Aug", 9: "Sep",
                          10: "Oct", 11: "Nov", 12: "Dec"]

    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let monthNumber = Int(value)
        return self.months[monthNumber] ?? "(\(monthNumber))"
    }
}
