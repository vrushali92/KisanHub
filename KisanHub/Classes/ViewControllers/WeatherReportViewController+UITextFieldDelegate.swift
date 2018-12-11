//
//  WeatherReportViewController+UITextFieldDelegate.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 11/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import UIKit

extension WeatherReportViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let pickerView = textField.inputView as? UIPickerView, let selectedYear = self.selectedYear, let year = Int(selectedYear) {
            pickerView.selectRow(self.yearArray.firstIndex(of: year) ?? 0, inComponent: 0, animated: true)
        }
        return true
    }
}
