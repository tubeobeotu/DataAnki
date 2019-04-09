//
//  ThemeView.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/9/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class ThemeView: BaseCustomNibView {
    @IBOutlet weak var v_Section: SectionView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var v_Default: ThemeOptionView!
    @IBOutlet weak var v_Dark: ThemeOptionView!
    @IBOutlet weak var v_Light: ThemeOptionView!
    override func setupViews() {
        super.setupViews()
        self.v_Section.lbl_Title.text = "THEME"
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(refreshView),
                                       name: .appBgMode,
                                       object: nil)
        refreshView()
    }
    @objc func refreshView(){
        self.v_Section.backgroundColor = AppPreference.sharedInstance.appBgMode.sectionBgColor
        self.v_Default.isSelected = AppPreference.sharedInstance.appBgMode == .Default
        self.v_Dark.isSelected = AppPreference.sharedInstance.appBgMode == .Dark
        self.v_Light.isSelected = AppPreference.sharedInstance.appBgMode == .White
        self.lbl_Title.text = AppPreference.sharedInstance.appBgMode.contentGuild
        self.lbl_Title.textColor = AppPreference.sharedInstance.appBgMode.contentGuildColor
    }
}
