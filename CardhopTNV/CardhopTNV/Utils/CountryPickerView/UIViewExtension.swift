//
//  UIViewExtension.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/10/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func setupHeaderView(text: String){
        let tmpView = UIView()
        self.addSubview(tmpView)
        tmpView.translatesAutoresizingMaskIntoConstraints = false
        let topTmpView = NSLayoutConstraint(item: tmpView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let leftTmpView = NSLayoutConstraint(item: tmpView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let bottomTmpView = NSLayoutConstraint(item: tmpView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let rightTmpView = NSLayoutConstraint(item: tmpView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        self.addConstraints([topTmpView, leftTmpView, bottomTmpView, rightTmpView])
        tmpView.backgroundColor = AppPreference.sharedInstance.settings.appBgMode.sectionBgColor
        tmpView.alpha = 0.3
        
        let label = UILabel()
        label.text = text
        label.textColor = AppPreference.sharedInstance.settings.appBgMode.sectionTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 16)
        let bottom = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -16)
        self.addConstraints([top, left, bottom, right])
    }
}
