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
    
    @IBOutlet weak var yearTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var yearTableView: UITableView!
    
    @IBOutlet private weak var graphView: LineChartView!
    
    @IBAction func locationChanged(_ sender: Any) {
        
        guard let selectedLocation = self.locationSegmentedControl.titleForSegment(at: self.locationSegmentedControl.selectedSegmentIndex) else { return }
        
//        switch selectedLocation {
//
//        case Location.UK.value:
//            let location = Location.location(fromString: Location.UK.value)
//            self.weatherReportModel.reportFor(location: location)
//
//        case Location.england.value:
//            let location = Location.location(fromString: Location.england.value)
//            self.weatherReportModel.reportFor(location: location)
//
//        case Location.scotland.value:
//            let location = Location.location(fromString: Location.scotland.value)
//            self.weatherReportModel.reportFor(location: location)
//
//        case Location.wales.value:
//            let location = Location.location(fromString: Location.wales.value)
//            self.weatherReportModel.reportFor(location: location)
//
//        default:
//            break
//        }
    }
    
    private let yearArray = ["2017", "2001", "2000", "1997", "1910"]
    
    private static let nibname = "CustomTableViewCell"
    private static let cellIdentifier = "CustomTableViewCellIdentifier"
    private var previousRowSelected: Int?
    private var isDropdownOpen: Bool = false
    private let weatherReportModel = WeatherReportViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSegmentControl()
        self.configureTableView()
    }
    
    private func configureSegmentControl() {
        
        let title = Location.allCases.enumerated()
        self.locationSegmentedControl.removeAllSegments()
        for value in title {
            self.locationSegmentedControl.insertSegment(withTitle: value.element.value, at: value.offset, animated: false)
        }
        self.locationSegmentedControl.selectedSegmentIndex = 0
        let segmentText = self.locationSegmentedControl.titleForSegment(at: self.locationSegmentedControl.selectedSegmentIndex)
        if let segmentText = segmentText {
            self.weatherReportModel.report(forLocation: Location.location(fromString: segmentText)) {[weak self] chartData in
                self?.graphView.data = chartData
            }
        }
    }
    
    private func configureTableView() {
        
        self.yearTableView.estimatedRowHeight = 36.0
        self.yearTableView.rowHeight = UITableView.automaticDimension
        
        self.yearTableView.estimatedSectionHeaderHeight = 36.0
        self.yearTableView.sectionHeaderHeight = UITableView.automaticDimension
        
        let typeSelf = type(of: self)
        let nib = UINib(nibName: typeSelf.nibname, bundle: nil)
        self.yearTableView.register(nib, forCellReuseIdentifier: typeSelf.cellIdentifier)
        
        let headerNib = UINib(nibName: String(describing: DropdownHeaderView.classForCoder()), bundle: nil)
        self.yearTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: DropdownHeaderView.identifier)
        self.yearTableView.dataSource = self
        self.yearTableView.delegate = self
    
    }
    
    private func configureChart() {
    
        self.graphView.chartDescription?.text = "Weather Report"
    }
}

extension WeatherReportViewController {
    
    private func handleDropDown() {
        
        let rowHeight: CGFloat
        
        if self.isDropdownOpen {
            rowHeight = self.yearTableViewHeightConstraint.constant + (self.yearTableView.estimatedRowHeight * CGFloat(yearArray.count))
        } else {
            rowHeight = self.yearTableViewHeightConstraint.constant - (self.yearTableView.estimatedRowHeight * CGFloat(yearArray.count))
        }
        
        UIView.animate(withDuration: 6) {
            self.yearTableViewHeightConstraint.constant = rowHeight
            self.view.setNeedsLayout()
            self.view.updateConstraintsIfNeeded()
        }
    }
}

extension WeatherReportViewController: DropdownHeaderViewDelegate {
    
    func didSelect(_ header: DropdownHeaderView?) {
        
        self.isDropdownOpen = !self.isDropdownOpen
        self.handleDropDown()
        
    }
}

extension WeatherReportViewController: UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.yearArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier, for: indexPath)
        cell.textLabel?.text = self.yearArray[indexPath.row]
        cell.textLabel?.textAlignment = .center
        
        if let previousRow = self.previousRowSelected,
            previousRow == indexPath.row {
            cell.accessoryType = .checkmark
            
        } else {
            cell.accessoryType = .none
        }
        cell.backgroundColor = UIColor.yellow
        return cell
    }
    
}

extension WeatherReportViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DropdownHeaderView.identifier)
        if let headerView = headerView as? DropdownHeaderView {
            headerView.delegate = self
            let index = self.previousRowSelected ?? 0
            headerView.headerTitle = self.yearArray[index]
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        self.isDropdownOpen = false
        self.handleDropDown()
        self.previousRowSelected = indexPath.row
        print(self.yearArray[indexPath.row])
        tableView.reloadData()
    }
}

extension WeatherReportViewController {
    
    func weatherReport(forLocation: Location) {
        
    }
}
