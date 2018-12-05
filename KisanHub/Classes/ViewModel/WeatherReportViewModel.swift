//
//  WeatherReportViewModel.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation
import Charts

protocol WeatherReportViewModelEventsDelegate: AnyObject {
    func handle(event: WeatherReportViewModel.Event)
}

final class WeatherReportViewModel {
    
    enum Event {
        case loading
        case reportAvailable
        case failed(Error)
    }
    
    private let interactor: Interactor = KisanHubInteractor()
    private var records: RecordMap?
    
    weak var eventDelegate: WeatherReportViewModelEventsDelegate?
    
    func fetchReport(forLocation location: Location) {
        
        self.interactor.fetchWeatherReportFor(location: location) {[weak self] result in
            performOnMain {
                switch result {
                case .success(let records):
                    self?.records = records
                    self?.eventDelegate?.handle(event: .reportAvailable)
                case .failed(let error):
                    self?.eventDelegate?.handle(event: .failed(error))
                }
            }
        }
    }
    
    func chartData(forYear year: Int) -> LineChartData? {
        guard let records = self.records else { return nil }
        
        return ChartDataBuilder.prepareChartData(fromRecords: records, year: year)
    }
    
    func yearRange() -> [Int]? {
        
        guard let records = self.records else {
            return nil
        }
        
        var sortedYears = [Int]()
        for element in records {
            sortedYears = element.value.compactMap { $0.year }
        }
        let objects = Set(sortedYears.map { $0 }).sorted(by: >)
        return objects
    }
}
