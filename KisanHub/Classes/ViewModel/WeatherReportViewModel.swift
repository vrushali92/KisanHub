//
//  WeatherReportViewModel.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation

final class WeatherReportViewModel {
    
    private let apiClient: APIClient = KisanHubAPIClient()
    
    func reportFor(location: Location) {
        
        self.apiClient.fetchWeatherReportFor(location: location) { result in
            result.forEach { record in
               print(record.key, "\(record.value.value != nil)")
            }
            
            let db = DataStore(fileName: "/MetaData.json", directory: .documentDirectory)
            db.save(data: result, forLocation: location, with: { status in
                print(status)
            })
        }
    }
}
