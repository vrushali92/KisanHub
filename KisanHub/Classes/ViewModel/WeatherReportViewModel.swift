//
//  WeatherReportViewModel.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 02/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation
import Charts

/// Handles WeatherReportViewModel's event
protocol WeatherReportViewModelEventsDelegate: AnyObject {
    func handle(event: WeatherReportViewModel.Event)
}

final class WeatherReportViewModel {
    
    /// Chart data state
    enum Event {
        case loading
        case reportAvailable
        case failed(Error)
    }
    
    // MARK: - Private properties
    private let interactor: Interactor = KisanHubInteractor()
    private var records: RecordMap?
    
    /// Event delegate object
    weak var eventDelegate: WeatherReportViewModelEventsDelegate?
    
    /// Fetch report based on selected location
    ///
    /// - Parameter location: selected location
    func fetchReport(forLocation location: Location) {
        self.eventDelegate?.handle(event: .loading)
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
    
    /// Get chartdata based on selected year
    ///
    /// - Parameter year: selected year
    /// - Returns: Data in chart data format
    func chartData(forYear year: Int) -> LineChartData? {
        guard let records = self.records else { return nil }
        
        return ChartDataBuilder.prepareChartData(fromRecords: records, year: year)
    }
    
    /// Sorts and removes duplicate years from records
    ///
    /// - Returns: array of year from records
    func yearRange() -> [Int]? {
        
        guard let records = self.records else {
            return nil
        }
        
        var sortedYears = Set<Int>()
        for element in records {
            sortedYears = Set(element.value.compactMap { $0.year })
        }
        let objects = Set(sortedYears.map { $0 }).sorted(by: >)
        return objects
    }
    
    /// Configures Ballon marker
    ///
    /// - Parameter chartView: Chartview to be configured
    func configureMarker(forChartView chartView: ChartViewBase) {
        let marker = BalloonMarker(color: UIColor.Marker.bodyColor,
                                   font: .preferredFont(forTextStyle: .callout),
                                   textColor: UIColor.Marker.textColor,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 16, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 40, height: 40)
        chartView.marker = marker
    }
}
