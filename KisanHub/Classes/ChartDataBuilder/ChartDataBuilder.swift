//
//  ChartDataBuilder.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 04/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation
import Charts

enum ChartDataBuilder {
    
    /// Returns records in LineChartData format
    ///
    /// - Parameters:
    ///   - records: all records
    ///   - year: selected Year
    /// - Returns: LinechartData
    static func prepareChartData(fromRecords records: RecordMap, year: Int) -> LineChartData? {
        
        let sets = records.compactMap { element -> ChartDataSet? in
            return self.createChartDataSet(data: element.value.filter({ $0.year == year }), key: element.key)
        }
        return LineChartData(dataSets: sets)
    }
    
    /// Returns ChartDataSet for metrics from array of record
    ///
    /// - Parameters:
    ///   - data: array of records
    ///   - key: metrics
    /// - Returns: ChartDataSet
    private static func createChartDataSet(data: [Record], key: Metrics) -> ChartDataSet {
        
        let dataPoints = data.map { ChartDataEntry(x: Double($0.month), y: $0.value) }
        let dataSet = LineChartDataSet(values: dataPoints, label: key.rawValue)
        dataSet.mode = .cubicBezier
        dataSet.setColor(key.color)
        dataSet.circleRadius = 4.0
        dataSet.setCircleColor(key.color)
        return dataSet
    }
}

private extension Metrics {
    
    /// Color for each metric to be highlighted on chart
    var color: UIColor {
        switch self {
        case .maxTemperature:
              return UIColor.Metrics.maxTemperature
        case .minTemperature:
              return UIColor.Metrics.minTemperature
        case .rainfall:
              return UIColor.Metrics.rainfall
        }
    }
}
