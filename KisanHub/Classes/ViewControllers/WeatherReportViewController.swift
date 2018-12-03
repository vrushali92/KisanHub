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
    
    @IBOutlet private weak var graphContainerView: UIView!
    
    @IBAction func locationChanged(_ sender: Any) {
        
        
    }
    
    
    private let yearArray = ["2017", "2001", "2000", "1997", "1910"]
    
    static private let nibname = "CustomTableViewCell"
    static private let cellIdentifier = "CustomTableViewCellIdentifier"
    private var previousRowSelected: Int?
    private var isDropdownOpen: Bool = false
    private let weatherReportModel = WeatherReportViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureTableView()
    }
    
    private func configureUI() {
        
        let title = Location.allCases.enumerated()
        self.locationSegmentedControl.removeAllSegments()
        for value in title {
            self.locationSegmentedControl.insertSegment(withTitle: value.element.rawValue, at: value.offset, animated: false)
        }
        self.locationSegmentedControl.selectedSegmentIndex = 0
        let segmentText = self.locationSegmentedControl.titleForSegment(at: self.locationSegmentedControl.selectedSegmentIndex)
        if let segmentText = segmentText {
            self.weatherReportModel.reportFor(location: (segmentText.locationForString()))
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.isDropdownOpen = false
        self.handleDropDown()
        self.previousRowSelected = indexPath.row
        tableView.reloadData()
    }
}

extension WeatherReportViewController {
    
    func weatherReport(forLocation: Location) {
        
    }
}




