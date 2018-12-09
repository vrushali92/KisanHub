//
//  WeatherReportViewController.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 01/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import UIKit
import Charts
import MBProgressHUD

final class WeatherReportViewController: UIViewController {
    
    private static let doneButton = "Done"
    private static let cancelButton = "Cancel"
    
    @IBOutlet private weak var locationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet private weak var graphView: LineChartView!
    
    private var yearArray = [Int]()
    private var lastSelectedYearString = String()
    
    private lazy var weatherReportModel: WeatherReportViewModel = {
        let viewModel = WeatherReportViewModel()
        viewModel.eventDelegate = self
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showActivity(withTitle: "Loading...", andMessage: nil)
        self.fetchReport(forLocation: .unitedKingdom)
        self.updateYears()
        self.configureUI()
        self.hideActivity()
    }
    
    private func configureUI() {
        
        self.configureSegmentControl()
        self.configurePickerView()
        self.configureTextField()
    }
    
    private func configureSegmentControl() {
        
        let title = Location.allCases.enumerated()
        self.locationSegmentedControl.removeAllSegments()
        for value in title {
            self.locationSegmentedControl.insertSegment(withTitle: value.element.value, at: value.offset, animated: false)
        }
        self.locationSegmentedControl.selectedSegmentIndex = 0
    }
    
    private func configurePickerView() {
        
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        self.configureToolBar()
        self.yearTextField.inputView = pickerView
    }
    
    private func configureTextField() {
        
        if let firstYear = self.yearArray.first {
            self.yearTextField.text = String(firstYear)
            self.lastSelectedYearString = self.yearTextField.text ?? ""
        }
        
        self.weatherReportModel.eventDelegate?.handle(event: .reportAvailable)
    }
    
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
    
    private func updateYears() {
        guard let yearRange = self.weatherReportModel.yearRange() else { return }
        self.yearArray = Array(yearRange)
    }
    
    private func fetchReport(forLocation location: Location) {
        self.weatherReportModel.fetchReport(forLocation: location)
    }
    
    @objc func doneClick() {
        
        self.lastSelectedYearString = self.yearTextField.text ?? ""
        self.weatherReportModel.eventDelegate?.handle(event: .reportAvailable)
        self.yearTextField.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        self.yearTextField.text = self.lastSelectedYearString
        self.yearTextField.resignFirstResponder()
    }
    
    @IBAction private func locationChanged(_ sender: Any?) {
        
        self.showActivity(withTitle: "Loading...", andMessage: nil)
        guard let selectedLocation = self.locationSegmentedControl.titleForSegment(at: self.locationSegmentedControl.selectedSegmentIndex) else { return }
        
        self.fetchReport(forLocation: Location.location(fromString: selectedLocation))
        self.weatherReportModel.eventDelegate?.handle(event: .reportAvailable)
        self.updateYears()
        self.hideActivity()
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

extension WeatherReportViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(self.yearArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.yearTextField.text = String(self.yearArray[row])
    }
}

extension WeatherReportViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.yearArray.count
    }
}

extension WeatherReportViewController {
    
    func showActivity(withTitle title: String?, andMessage message: String?) {
        ActivityIndicatorProvider.shared.showActivity(onView: self.view, withTitle: title, andMessage: message)
    }
    
    func hideActivity() {
        ActivityIndicatorProvider.shared.hideActivity()
    }
}
