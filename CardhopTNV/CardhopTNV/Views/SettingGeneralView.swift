//
//  SettingGeneralView.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/9/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
enum OptionIndexType:Int{
    case SortBy = 0
    case DisplayName = 1
    case AddressFormat = 2
    case DefaultCountryCode = 3
    case DefaultAccount = 4
    
    var title: String{
        get{
            switch(self){
            case .SortBy: return "Sort By"
            case .DisplayName: return "Display Name"
            case .AddressFormat: return "Address Format"
            case .DefaultCountryCode: return "Default Country Code"
            case .DefaultAccount: return "Default Account"
                
            }
        }
    }
    
}
protocol SettingGeneralViewDelegate: SettingGeneralOptionViewDelegate{
}
class SettingGeneralView: BaseCustomNibView {
    var delegate:SettingGeneralViewDelegate?
    @IBOutlet weak var v_Section: SectionView!
    @IBOutlet weak var v_SortBy: SettingGeneralOptionView!
    
    @IBOutlet weak var v_DisplayName: SettingGeneralOptionView!
    @IBOutlet weak var v_AddressFormat: SettingGeneralOptionView!
    
    @IBOutlet weak var v_DefaultCountryCode: SettingGeneralOptionView!
    
    override func setupViews() {
        super.setupViews()
        self.v_Section.lbl_Title.text = "GENERAL"
        self.v_SortBy.delegate = self
        self.v_SortBy.type = .SortBy
        self.v_DisplayName.delegate = self
        self.v_DisplayName.type = .DisplayName
        self.v_AddressFormat.delegate = self
        self.v_AddressFormat.type = .AddressFormat
        self.v_DefaultCountryCode.delegate = self
        self.v_DefaultCountryCode.type = .DefaultCountryCode
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(refreshView),
                                       name: .appBgMode,
                                       object: nil)
        refreshView()
    }
    @objc func refreshView(){
        self.v_Section.backgroundColor = AppPreference.sharedInstance.settings.appBgMode.sectionBgColor
        self.v_Section.lbl_Title.textColor = AppPreference.sharedInstance.settings.appBgMode.sectionTextColor
        self.v_SortBy.refreshUI()
        self.v_DisplayName.refreshUI()
        self.v_AddressFormat.refreshUI()
        self.v_DefaultCountryCode.refreshUI()
    }
}
extension SettingGeneralView: SettingGeneralOptionViewDelegate{
    func didSelectOption(type: OptionIndexType) {
        self.delegate?.didSelectOption(type: type)
    }
}
