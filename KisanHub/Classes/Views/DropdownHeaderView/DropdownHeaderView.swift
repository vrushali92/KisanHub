//
//  DropdownHeaderView.swift
//  DropDown
//
//  Created by Vrushali Kulkarni on 23/05/17.
//  Copyright © 2017 Vrushali Kulkarni. All rights reserved.
//

import UIKit

protocol DropdownHeaderViewDelegate: class {
    
    func didSelect(_ header: DropdownHeaderView?)
}

final class DropdownHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var accessoryImageView: UIImageView!
    @IBOutlet private weak var touchableView: UIView!

    weak var delegate: DropdownHeaderViewDelegate?
    static let identifier = "DropdownHeaderViewDelegateIdentifier"
    
    var headerTitle = "" {
        didSet {
            self.title.text = self.headerTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }   
}

extension DropdownHeaderView {

    private func prepare() {
    
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchableViewTapped))
        
        self.touchableView.addGestureRecognizer(gestureRecognizer)
        self.accessoryImageView.image = UIImage(named: "ArrowUp_Down")
        self.title.textAlignment = .center
    }
    
    @objc private func touchableViewTapped() {
        
        guard let delegate = self.delegate else { return }
        delegate.didSelect(self)
    }
}

//extension DropdownHeaderView {
//    static var nib: UINib {
//        return UINib(nibName: String(describing: self.classForCoder()), bundle: nil)
//    }
//
//
//
//    static func register(inTableView tableView: UITableView) {
//        tableView.register(self.nib, forHeaderFooterViewReuseIdentifier: self.identifier)
//    }
//
//    static func deque(forTableView tableView: UITableView) -> DropdownHeaderView {
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DropdownHeaderView.identifier)
//        guard let dropdownHeaderView = headerView as? DropdownHeaderView else {
//            return DropdownHeaderView(reuseIdentifier: self.identifier)
//        }
//
//        return dropdownHeaderView
//    }
//}
