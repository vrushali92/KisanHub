//
//  ActivityIndicatorProvider.swift
//  KisanHub
//
//  Created by Vrushali Kulkarni on 09/12/18.
//  Copyright © 2018 Vrushali Kulkarni. All rights reserved.
//

import Foundation
import MBProgressHUD

final class ActivityIndicatorProvider {
    /// Shared
    static let shared = ActivityIndicatorProvider()
    
    private weak var activeHud: MBProgressHUD?
    
    private init () {}
    
    /**
     Shows activity indicator on provided view with optional title and message.
     If any existing active indicator is found then removes that before showing new one.
     
     - Parameters:
     - view: A view on which activity indicator will be displayed.
     - title: Title for activity indicator.
     - message: Message for activity indicator.
     */
    func showActivity(onView view: UIView,
                      withTitle title: String?,
                      andMessage message: String?) {
        performOnMain {
            if self.activeHud != nil {
                self.hideActivity()
            }
            
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = title
            hud.detailsLabel.text = message
            view.bringSubviewToFront(hud)
            self.activeHud = hud
        }
    }
    
    /// Hides active activity indicator
    func hideActivity() {
        performOnMain {
            self.activeHud?.hide(animated: true)
            self.activeHud = nil
        }
    }
}
