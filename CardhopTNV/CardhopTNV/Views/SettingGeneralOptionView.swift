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
    @IBOutlet weak var btn_Image: UIButton!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Content: UILabel!
    var delegate:SettingGeneralOptionViewDelegate?
    var type:OptionIndexType = .SortBy{
        didSet{
            self.lbl_Title.text = type.title
            switch type {
            case .SortBy:
                self.lbl_Content.text = AppPreference.sharedInstance.settings.sortType
                break
            case .DisplayName:
                self.lbl_Content.text = AppPreference.sharedInstance.settings.displayName
                break
            case .DefaultCountryCode:
                self.lbl_Content.text = AppPreference.sharedInstance.settings.defaultCountryTitle()
                break
            case .AddressFormat:
                self.lbl_Content.text = AppPreference.sharedInstance.settings.addressFormatTitle()
                break
            default:
                break
                
            }
        }
    }
    func refreshUI(){
        self.btn_Image.tintColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.lbl_Title.textColor =  AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.lbl_Content.textColor = AppPreference.sharedInstance.settings.appBgMode.cellContentTextColor
    }

    @IBAction func didTap(_ sender: Any) {
        self.delegate?.didSelectOption(type: self.type)
    }
}
