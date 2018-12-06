//
//  WeatherReportViewController.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 01/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import UIKit
import Charts

final class WeatherReportViewController: UIViewController {
    
    @IBOutlet private weak var locationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet private weak var graphView: LineChartView!

    private var yearArray = [2017, 2001, 2000, 1997, 1910]

    private lazy var weatherReportModel: WeatherReportViewModel = {
        let viewModel = WeatherReportViewModel()
        viewModel.eventDelegate = self
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.fetchReport(forLocation: .unitedKingdom)
        self.updateYears()
    }
    
    private func configureUI() {
        self.configureSegmentControl()
        self.configureChart()
        self.configureDatePickerView()
    }
    
    private func configureSegmentControl() {
        
        let title = Location.allCases.enumerated()
        self.locationSegmentedControl.removeAllSegments()
        for value in title {
            self.locationSegmentedControl.insertSegment(withTitle: value.element.value, at: value.offset, animated: false)
        }
        self.locationSegmentedControl.selectedSegmentIndex = 0
    }
    
    private func configureDatePickerView() {
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self,
                                 action: #selector(WeatherReportViewController.dateChanged(datePickerView:)),
                                 for: .valueChanged)
        
        self.yearTextField.inputView = datePickerView
    }
    
    @objc func dateChanged(datePickerView: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        self.yearTextField.text = dateFormatter.string(from: datePickerView.date)
        self.weatherReportModel.eventDelegate?.handle(event: .reportAvailable)
        self.view.endEditing(true)
    }
    
    private func configureChart() {
    
        self.graphView.chartDescription?.text = "Weather Report"
    }
    
    private func updateYears() {
    
        guard let yearRange = self.weatherReportModel.yearRange() else { return }
        self.yearArray = Array(yearRange)
    }
    
    private func fetchReport(forLocation location: Location) {
        self.weatherReportModel.fetchReport(forLocation: location)
    }
    
    @IBAction private func locationChanged(_ sender: Any?) {
        
        guard let selectedLocation = self.locationSegmentedControl.titleForSegment(at: self.locationSegmentedControl.selectedSegmentIndex) else { return }
        
        self.fetchReport(forLocation: Location.location(fromString: selectedLocation))
        self.weatherReportModel.eventDelegate?.handle(event: .reportAvailable)
        self.updateYears()
    }
}

extension WeatherReportViewController: WeatherReportViewModelEventsDelegate {
    func handle(event: WeatherReportViewModel.Event) {
        switch event {
        case .loading:
            print("Show loading view")
        case .failed(let error):
            print(error)
        case .reportAvailable:
            if let year = self.yearTextField.text, let year1 = Int(year) {
                self.graphView.data = self.weatherReportModel.chartData(forYear: year1)
            }
        }
    }
}
