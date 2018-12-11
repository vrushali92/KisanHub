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
    
    // MARK: - Constants
    private static let doneButton = "Done"
    private static let cancelButton = "Cancel"
    private static let activityIndicatorTitle = "Loading chart"
    
    // MARK: - Outlets
    @IBOutlet private weak var locationSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var yearTextField: UITextField! {
        didSet {
            self.yearTextField.delegate = self
        }
    }
    @IBOutlet private weak var graphView: LineChartView!
    
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
    var yearArray = [Int]()

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
            self.yearTextField.text = String(firstYear)
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
        self.lastSelectedYearString = self.yearTextField.text
        self.yearTextField.resignFirstResponder()
        if let yearString = self.lastSelectedYearString, let selectedYear = Int(yearString) {
            self.updateChart(withSelectedYear: selectedYear)
        }
    }
    
    /// Reset to last selected year on tap of cancel
    @objc private func cancelClick() {
        self.yearTextField.text = self.lastSelectedYearString ?? ""
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

// MARK: - UIPickerViewDelegate
extension WeatherReportViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(self.yearArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.yearTextField.text = String(self.yearArray[row])
    }
}

// MARK: - UIPickerViewDataSource
extension WeatherReportViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.yearArray.count
    }
}

extension WeatherReportViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.inputView === self.pickerView,
            let selectedYear = self.lastSelectedYearString,
            let year = Int(selectedYear) {
            self.pickerView.selectRow(self.yearArray.firstIndex(of: year) ?? 0, inComponent: 0, animated: true)
        }
        return true
    }
}
