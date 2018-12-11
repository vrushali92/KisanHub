//
//  WeatherReportViewController+UIPickerView.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 11/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import UIKit

// MARK: - UIPickerViewDelegate
extension WeatherReportViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(self.yearArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedYear = String(self.yearArray[row])
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
