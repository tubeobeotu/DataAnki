//
//  AppPreference.swift
//  CardhopTNV
//
//  Created by Tu on 4/6/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import Foundation
import UIKit
import Contacts
enum AppBgMode:String {
    case Default = "0"
    case Dark = "1"
    case White = "2"
    
    var text: String{
        get{
            switch(self){
            case .Default: return "Default"
            case .Dark: return "Dark"
            case .White: return "White"
            }
            
        }
    }
    var themeImage: UIImage?{
        get{
            switch(self){
            case .Default: return UIImage(named: "ic_default")
            case .Dark: return UIImage(named: "ic_dark")
            case .White: return UIImage(named: "ic_white")
            }
            
        }
    }
    var contentGuild: String{
        get{
            switch(self){
            case .Default: return "Dark list and light contact cards."
            case .Dark: return "Dark list and dark contact cards"
            case .White: return "Light list and light contact cards."
            }
        }
    }
    var contentGuildColor: UIColor{
        get{
            if(AppPreference.sharedInstance.isDetailVC){
                switch(self){
                case .Dark: return UIColor.init(rgb: 0x676767)
                case .Default, .White: return UIColor.init(rgb: 0x38393B)
                }
            }else{
                switch(self){
                case .Default: return UIColor.init(rgb: 0x676767)
                case .Dark: return UIColor.init(rgb: 0x676767)
                case .White: return UIColor.init(rgb: 0x38393B)
                }
            }
            
        }
    }
    
    var sectionBgColor: UIColor{
        get{
            if(AppPreference.sharedInstance.isDetailVC){
                
            }else{
                
            }
            switch(self){
            case .Dark: return UIColor.black
            case .Default, .White: return UIColor.init(rgb: 0xEDEDED)
            }
        }
    }
    
    var bgColor: UIColor{
        get{
            if(AppPreference.sharedInstance.isDetailVC){
                switch(self){
                case .Dark: return UIColor.black
                case .Default, .White: return UIColor.init(rgb: 0xF5F8F8)
                }
            }else{
                switch(self){
                case .Default: return UIColor.black
                case .Dark: return UIColor.black
                case .White: return UIColor.init(rgb: 0xF5F8F8)
                }
            }
            
        }
    }
    
    var sectionTextColor: UIColor{
        get{
            if(AppPreference.sharedInstance.isDetailVC){
                switch(self){
                case .Dark: return UIColor.init(rgb: 0x979695)
                case .Default, .White: return UIColor.init(rgb: 0x979695)
                }
            }else{
                switch(self){
                case .Default: return UIColor.init(rgb: 0x979695)
                case .Dark: return UIColor.init(rgb: 0x979695)
                case .White: return UIColor.init(rgb: 0x979695)
                }
            }
            
        }
    }
    var cellTitleTextColor: UIColor{
        get{
            if(AppPreference.sharedInstance.isDetailVC){
                switch(self){
                case .Dark: return UIColor.white
                case .Default, .White: return UIColor.black
                }
            }else{
                switch(self){
                case .Default: return UIColor.white
                case .Dark: return UIColor.white
                case .White: return UIColor.black
                }
            }
            
        }
    }
    var cellContentTextColor: UIColor{
        get{
            if(AppPreference.sharedInstance.isDetailVC){
                switch(self){
                case .Dark: return UIColor.init(rgb: 0x979695)
                case .Default, .White: return UIColor.init(rgb: 0x979695)
                }
            }else{
                switch(self){
                case .Default: return UIColor.init(rgb: 0x979695)
                case .Dark: return UIColor.init(rgb: 0x979695)
                case .White: return UIColor.init(rgb: 0x979695)
                }
            }
            
        }
    }
    
    
    var appTitleColor: UIColor{
        if(AppPreference.sharedInstance.isDetailVC){
            if(AppPreference.sharedInstance.settings.appBgMode == .Default){
                return UIColor.white
            }else{
                return UIColor.black
            }
        }else{
            if(AppPreference.sharedInstance.settings.appBgMode == .White){
                return UIColor.black
            }else{
                return UIColor.white
            }
        }
        
    }
    var bgColorCell: UIColor{
        get{
            if(AppPreference.sharedInstance.isDetailVC){
                switch(self){
                case .Dark: return UIColor.init(rgb: 0x1C1C1C)
                case .Default, .White: return UIColor.init(rgb: 0xEFEEEC)
                }
            }else{
                switch(self){
                case .Default: return UIColor.init(rgb: 0x1C1C1C)
                case .Dark: return UIColor.init(rgb: 0x1C1C1C)
                case .White: return UIColor.init(rgb: 0xEFEEEC)
                }
            }
            
        }
    }
    
    var selectedThemeBg: UIColor{
        get{
            if(AppPreference.sharedInstance.isDetailVC){
                switch(self){
                case .Dark: return UIColor.init(rgb: 0x0091FB)
                case .Default, .White: return UIColor.init(rgb: 0x0091FB)
                }
            }else{
                switch(self){
                case .Default: return UIColor.init(rgb: 0x0091FB)
                case .Dark: return UIColor.init(rgb: 0x0091FB)
                case .White: return UIColor.init(rgb: 0x0091FB)
                }
            }
            
        }
    }
    var unSelectedThemeBg: UIColor{
        get{
            if(AppPreference.sharedInstance.isDetailVC){
                switch(self){
                case .Dark: return UIColor.init(rgb: 0x292929)
                case .Default, .White: return UIColor.init(rgb: 0xEAEAE9)
                }
            }else{
                switch(self){
                case .Default: return UIColor.init(rgb: 0x292929)
                case .Dark: return UIColor.init(rgb: 0x292929)
                case .White: return UIColor.init(rgb: 0xEAEAE9)
                }
            }
            
        }
    }
}
open class AppPreference {
    let contactStore = CNContactStore()
    //MARK: Shared Instance
    static let sharedInstance : AppPreference = {
        let instance = AppPreference(array: [])
        let tabBarController = UITabBarController.init()
        instance.settings = GeneralSettingModel()
        instance.tabbarHeight = tabBarController.tabBar.frame.size.height
        return instance
    }()
    
    //MARK: Local Variable
    var isDetailVC = false
    var settings:GeneralSettingModel!
    var siriView:SearchingView!
    var contacts = [ContactModel]()
    var recentContacts = [ContactModel]()
    var favouritContacts = [ContactModel]()
    var birthdayContacts = [ContactModel]()
    
    var emptyStringArray : [String]
    var tabbarHeight:CGFloat = 0
    var marginSearchView:CGFloat = 16
    let searchViewHeight:CGFloat = 40
    //MARK: Init
    
    init( array : [String]) {
        emptyStringArray = array
    }
    func getAppBgColor() -> UIColor{
        if(isDetailVC == false){
            return AppPreference.sharedInstance.settings.appBgMode.bgColor
        }else{
            if(AppPreference.sharedInstance.settings.appBgMode == .Default){
                return AppBgMode.White.bgColor
            }else{
                return AppBgMode.Dark.bgColor
            }
        }
    }
    
    var countries: [CountryModel] = {
        var countries = [CountryModel]()
        let bundle = Bundle(for: ContactCountryVC.self)
        guard let jsonPath = bundle.path(forResource: "CountryPickerView.bundle/Data/CountryCodes", ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
                return countries
        }
        
        if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization
            .ReadingOptions.allowFragments)) as? Array<Any> {
            
            for jsonObject in jsonObjects {
                
                guard let countryObj = jsonObject as? Dictionary<String, Any> else {
                    continue
                }
                
                guard let name = countryObj["name"] as? String,
                    let code = countryObj["code"] as? String,
                    let phoneCode = countryObj["dial_code"] as? String else {
                        continue
                }
                
                let country = CountryModel(name: name, code: code, phoneCode: phoneCode)
                countries.append(country)
            }
            
        }
        
        return countries
    }()
    
    func getNormalCellHeight() -> CGFloat{
        return 50
    }
    func changeNavMode(nav: UINavigationController?, isDetail:Bool = false){
        if(isDetail == true){
            if(AppPreference.sharedInstance.settings.appBgMode == .White || AppPreference.sharedInstance.settings.appBgMode == .Default){
                nav?.navigationBar.barStyle = UIBarStyle.default
            }else{
                nav?.navigationBar.barStyle = UIBarStyle.black
            }
        }else{
            if(AppPreference.sharedInstance.settings.appBgMode == .White){
                nav?.navigationBar.barStyle = UIBarStyle.default
            }else{
                nav?.navigationBar.barStyle = UIBarStyle.black
            }
        }
        
    }
}

extension Notification.Name {
    static let appBgMode = Notification.Name(
        rawValue: "appBgMode")
}
