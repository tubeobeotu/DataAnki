//
//  GeneralSettingModel.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/10/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class GeneralSettingModel: BaseModel {
    var sortType = "" //First Name, List name
    var displayName = "" //First Last(John Doe), Last First(Doe John), Last, First(Doe, John)
    var addressFormat = ""
    var defaultCountryCode = ""
    var defaultAccount = ""
    var appBgMode:AppBgMode = .Default{
        didSet{
            NotificationCenter.default.post(name: .appBgMode, object: nil, userInfo: nil)
        }
    }
    init(dictionary: Dictionary<String, String>){
        self.sortType = dictionary["sortType"] ?? ""
        self.displayName = dictionary["displayName"] ?? ""
        self.addressFormat = dictionary["addressFormat"] ?? ""
        self.defaultCountryCode = dictionary["defaultCountryCode"] ?? ""
        self.defaultAccount = dictionary["defaultAccount"] ?? ""
        
        self.appBgMode =  AppBgMode.init(rawValue: dictionary["appBgMode"] ?? AppBgMode.Default.rawValue) ?? .Default
    }
    override init() {
        
    }
    func toDict() -> Dictionary<String, String>{
        var dict = Dictionary<String, String>()
        dict["sortType"] = self.sortType
        dict["displayName"] = self.displayName
        dict["addressFormat"] = self.addressFormat
        dict["defaultCountryCode"] = self.defaultCountryCode
        dict["defaultAccount"] = self.defaultAccount
        dict["appBgMode"] = self.appBgMode.rawValue
        return dict
    }
}
