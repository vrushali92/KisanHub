//
//  WeatherReportViewModel.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation
import Charts

final class WeatherReportViewModel {
    
    private let apiClient: Interactor = KisanHubInteractor()
    
    func report(forLocation location: Location, with completionHandler: @escaping (ChartData) -> Void) {
        
        self.apiClient.fetchWeatherReportFor(location: location) { result in
            result.forEach { record in
               print(record.key, "\(record.value.value != nil)")
            }
            performOnMain {
                
                let chartData = ChartDataBuilder(data: result, location: location)
                let data = chartData.prepareChartData(forLocation: location, year: 2011)
                if let data = data {
                    completionHandler(data)
                }
                
            }
            let database = DataStore(fileName: "MetaData.json", directory: .documentDirectory)
            database.save(data: result, forLocation: location, with: { status in
                print(status)
            })
        }
    }
}
