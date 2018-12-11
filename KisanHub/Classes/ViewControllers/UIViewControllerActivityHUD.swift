//
//  UIViewControllerActivityHUD.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 11/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import UIKit

protocol ActivityHUDDisplaying {
    func showActivity(withTitle title: String?, andMessage message: String?)
    func hideActivity()
}

extension ActivityHUDDisplaying where Self: UIViewController {
    func showActivity(withTitle title: String?, andMessage message: String?) {
        ActivityIndicatorProvider.shared.showActivity(onView: self.view, withTitle: title, andMessage: message)
    }
    
    func hideActivity() {
        ActivityIndicatorProvider.shared.hideActivity()
    }
}
