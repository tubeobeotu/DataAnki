//
//  SettingGeneralOptionView.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/9/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
protocol SettingGeneralOptionViewDelegate{
    func didSelectOption(type: OptionIndexType)
}
class SettingGeneralOptionView: BaseCustomNibView {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Content: UILabel!
    var delegate:SettingGeneralOptionViewDelegate?
    var type:OptionIndexType = .SortBy{
        didSet{
            self.lbl_Title.text = type.title
        }
    }
    func refreshUI(){
        self.lbl_Title.textColor = AppPreference.sharedInstance.appBgMode.cellTitleTextColor
        self.lbl_Content.textColor = AppPreference.sharedInstance.appBgMode.cellContentTextColor
    }

    @IBAction func didTap(_ sender: Any) {
        self.delegate?.didSelectOption(type: self.type)
    }
}
