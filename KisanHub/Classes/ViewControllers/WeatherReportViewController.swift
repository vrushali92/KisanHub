//
//  WeatherReportViewController.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 01/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import UIKit
import Charts

final class WeatherReportViewController: UIViewController, ActivityHUDDisplaying {
    
    // MARK: - Constants
    private static let doneButton = "Done"
    private static let cancelButton = "Cancel"
    private static let activityIndicatorTitle = "Loading chart"
    private static let graphTitle = "Kisan Hub"
    
    // MARK: - Outlets
    @IBOutlet private weak var locationSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var yearTextField: UITextField! {
        didSet {
            self.yearTextField.delegate = self
        }
    }
    @IBOutlet private weak var graphView: LineChartView!
    @IBOutlet weak var graphTitleLabel: UILabel!
    
    // MARK: - Private properties
    private var lastSelectedYearString: String?
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = true
        return pickerView
    }()
    
    private lazy var weatherReportModel: WeatherReportViewModel = {
        let viewModel = WeatherReportViewModel()
        viewModel.eventDelegate = self
        return viewModel
    }()
    
    // MARK: - Public properties
    private(set) var yearArray = [Int]()
    var selectedYear: String? {
        get {
            return self.yearTextField.text
        }
        set {
            self.yearTextField.text = newValue
        }
    }
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.fetchReport(forLocation: .unitedKingdom)
    }
    
    /// Configure Subviews
    private func configureUI() {
        self.configureSegmentControl()
        self.configureToolBar()
        self.configureTextField()
        self.configureChartView()
    }
    
    private func configureChartView() {
        self.graphTitleLabel.text = type(of: self).graphTitle
        self.graphView.drawGridBackgroundEnabled = false
        self.graphView.setScaleEnabled(false)
        let marker = BalloonMarker(color: UIColor(white: 180 / 255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = self.graphView
        marker.minimumSize = CGSize(width: 80, height: 40)
        self.graphView.marker = marker
    }
    
    /// Configure UISegmentControl
    private func configureSegmentControl() {
        let title = Location.allCases.enumerated()
        self.locationSegmentedControl.removeAllSegments()
        for value in title {
            self.locationSegmentedControl.insertSegment(withTitle: value.element.value, at: value.offset, animated: false)
        }
        self.locationSegmentedControl.selectedSegmentIndex = 0
    }
    
    /// Configure UITextField
    private func configureTextField() {
        self.yearTextField.inputView = self.pickerView
    }
    
    /// Configure Done and Cancel button of UIPickerView
    private func configureToolBar() {
        let toolBar = UIToolbar()
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let typeSelf = type(of: self)
        
        let doneButton = UIBarButtonItem(title: typeSelf.doneButton,
                                         style: .done,
                                         target: self,
                                         action: #selector(WeatherReportViewController.doneClick))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: typeSelf.cancelButton,
                                           style: .plain,
                                           target: self,
                                           action: #selector(WeatherReportViewController.cancelClick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.yearTextField.inputAccessoryView = toolBar
    }
}

extension WeatherReportViewController {
    
    /// Update year field on tap of location segment control
    private func updateYearTextField() {
        if let firstYear = self.yearArray.first {
            self.selectedYear = String(firstYear)
        }
    }
    
    /// Update years array on tap of location segment control
    private func updateYears() {
        guard let years = self.weatherReportModel.yearRange(), !years.isEmpty else { return }
        self.yearArray = years
        self.updateChart(withSelectedYear: years[0])
    }
    
    /// Fetch weather report based on selected location
    ///
    /// - Parameter location: selected location
    private func fetchReport(forLocation location: Location) {
        self.weatherReportModel.fetchReport(forLocation: location)
    }
    
    /// Update chart data based on changing year from UIPickerView
    ///
    /// - Parameter year: selected year from UIPickerView
    private func updateChart(withSelectedYear year: Int) {
        self.graphView.data = self.weatherReportModel.chartData(forYear: year)
    }
    
    /// Updates chart based on selected year on tap of done button
    @objc private func doneClick() {
        self.lastSelectedYearString = self.selectedYear
        self.yearTextField.resignFirstResponder()
        if let yearString = self.lastSelectedYearString, let selectedYear = Int(yearString) {
            self.updateChart(withSelectedYear: selectedYear)
        }
    }
    
    /// Reset to last selected year on tap of cancel
    @objc private func cancelClick() {
        self.selectedYear = self.lastSelectedYearString ?? ""
        self.yearTextField.resignFirstResponder()
    }
    
    // MARK: - IBAction
    @IBAction private func locationChanged(_ sender: Any?) {
        self.yearTextField.resignFirstResponder()
        guard let selectedLocation = self.locationSegmentedControl.titleForSegment(at: self.locationSegmentedControl.selectedSegmentIndex) else { return }
        self.fetchReport(forLocation: Location.location(fromString: selectedLocation))
    }
}

// MARK: - WeatherReportViewModelEventsDelegate
extension WeatherReportViewController: WeatherReportViewModelEventsDelegate {
    func handle(event: WeatherReportViewModel.Event) {
        switch event {
        case .loading:
            self.showActivity(withTitle: type(of: self).activityIndicatorTitle, andMessage: nil)
            
        case .failed(let error):
            self.hideActivity()
            print(error)
            
        case .reportAvailable:
            self.hideActivity()
            self.updateYears()
            self.updateYearTextField()
        }
    }
}
