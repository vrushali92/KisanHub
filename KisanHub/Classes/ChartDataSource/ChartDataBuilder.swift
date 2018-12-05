//
//  ChartDataBuilder.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 04/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation
import Charts

final class ChartDataBuilder {
    
    let rawChartData: ResultMap
    let location: Location
    
    init(data: ResultMap, location: Location) {
        self.rawChartData = data
        self.location = location
    }
    
    func prepareChartData(forLocation location: Location, year: Int) -> LineChartData? {
        
        let data = self.rawChartData.reduce(into: [Metrics: [Record]](), { base, element in
            if let records = element.value.value {
                base[element.key] = records
            }
        })
    
        let sets = data.compactMap { element -> ChartDataSet? in
            return self.createChartDataSet(data: element.value.filter({ $0.year == year }), key: element.key)
            
        }

        return LineChartData(dataSets: sets)
        
    }
    
    private func createChartDataSet(data: [Record], key: Metrics) -> ChartDataSet {
        
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
    var color: UIColor {
        switch self {
        case .maxTemperature:
              return UIColor.red
//            return UIColor(red: 136/255, green: 235/255, blue: 255/255, alpha: 1)
        case .minTemperature:
              return UIColor.green
//            return UIColor(red: 255/255, green: 210/255, blue: 139/255, alpha: 1)
        case .rainfall:
              return UIColor.blue
//            return UIColor(red: 255/255, green: 247/255, blue: 138/255, alpha: 1)
        }
    }
}
