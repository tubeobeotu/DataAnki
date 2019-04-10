//
//  GeneralSettingModel.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/10/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class GeneralSettingModel: BaseModel {
    var sortType:SortBy = .FirstNameLastName{
        didSet{
            SimpleFunction.calculateBirthdayContacts(contacts: AppPreference.sharedInstance.contacts)
        }
    }
    var displayName:DisplayName = .FistLast //First Last(John Doe), Last First(Doe John), Last, First(Doe, John)
    var addressFormat = ""
    var defaultCountryCode = ""
    var defaultAccount = ""
    var appBgMode:AppBgMode = .Default{
        didSet{
            NotificationCenter.default.post(name: .appBgMode, object: nil, userInfo: nil)
        }
    }
    init(dictionary: Dictionary<String, String>){
        self.sortType = SortBy(rawValue: dictionary["sortType"] ?? "") ?? .FirstNameLastName
        self.displayName = DisplayName(rawValue: dictionary["displayName"] ?? "") ?? DisplayName.FistLast
        self.addressFormat = dictionary["addressFormat"] ?? ""
        self.defaultCountryCode = dictionary["defaultCountryCode"] ?? ""
        self.defaultAccount = dictionary["defaultAccount"] ?? ""
        self.appBgMode =  AppBgMode(rawValue: dictionary["appBgMode"] ?? AppBgMode.Default.rawValue) ?? .Default
    }
    override init() {
        
    }
    func toDict() -> Dictionary<String, String>{
        var dict = Dictionary<String, String>()
        dict["sortType"] = self.sortType.rawValue
        dict["displayName"] = self.displayName.rawValue
        dict["addressFormat"] = self.addressFormat
        dict["defaultCountryCode"] = self.defaultCountryCode
        dict["defaultAccount"] = self.defaultAccount
        dict["appBgMode"] = self.appBgMode.rawValue
        return dict
    }
    
    func addressFormatTitle() -> String{
        let country = AppPreference.sharedInstance.countries.filter { (country) -> Bool in
            country.code == self.addressFormat
        }.first
        return country?.name ?? ""
    }
    func defaultCountryTitle() -> String{
        let country = AppPreference.sharedInstance.countries.filter { (country) -> Bool in
            country.code == self.defaultCountryCode
        }.first
        
        return "\(country?.phoneCode ?? "") (\(country?.name ?? ""))"
    }
}
