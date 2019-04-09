//
//  AppPreference.swift
//  CardhopTNV
//
//  Created by Tu on 4/6/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import Foundation
import UIKit
enum AppBgMode:Int {
    case Default = 0
    case Dark = 1
    case White = 2
    
    var text: String{
        get{
            switch(self){
            case .Default: return "Default"
            case .Dark: return "Dark"
            case .White: return "White"
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
            switch(self){
            case .Default: return UIColor.init(rgb: 0x676767)
            case .Dark: return UIColor.init(rgb: 0x676767)
            case .White: return UIColor.init(rgb: 0x38393B)
            }
        }
    }
    var sectionBgColor: UIColor{
        get{
            switch(self){
            case .Default: return UIColor.black
            case .Dark: return UIColor.black
            case .White: return UIColor.init(rgb: 0xEDEDED)
            }
        }
    }
    
    var bgColor: UIColor{
        get{
            switch(self){
            case .Default: return UIColor.black
            case .Dark: return UIColor.black
            case .White: return UIColor.init(rgb: 0xF5F8F8)
            }
        }
    }
    
    var sectionTextColor: UIColor{
        get{
            switch(self){
            case .Default: return UIColor.white
            case .Dark: return UIColor.white
            case .White: return UIColor.init(rgb: 0x979695)
            }
        }
    }
    var cellTitleTextColor: UIColor{
        get{
            switch(self){
            case .Default: return UIColor.white
            case .Dark: return UIColor.white
            case .White: return UIColor.black
            }
        }
    }
    var cellContentTextColor: UIColor{
        get{
            switch(self){
            case .Default: return UIColor.init(rgb: 0x979695)
            case .Dark: return UIColor.init(rgb: 0x979695)
            case .White: return UIColor.init(rgb: 0x979695)
            }
        }
    }
    
    
    var appTitleColor: UIColor{
        if(AppPreference.sharedInstance.appBgMode == .White){
            return UIColor.black
        }else{
            return UIColor.white
        }
    }
    var bgColorCell: UIColor{
        get{
            switch(self){
            case .Default: return UIColor.init(rgb: 0x1C1C1C)
            case .Dark: return UIColor.init(rgb: 0x1C1C1C)
            case .White: return UIColor.init(rgb: 0xEFEEEC)
            }
        }
    }
    
    var selectedThemeBg: UIColor{
        get{
            switch(self){
            case .Default: return UIColor.init(rgb: 0x0091FB)
            case .Dark: return UIColor.init(rgb: 0x0091FB)
            case .White: return UIColor.init(rgb: 0x0091FB)
            }
        }
    }
    var unSelectedThemeBg: UIColor{
        get{
            switch(self){
            case .Default: return UIColor.init(rgb: 0x292929)
            case .Dark: return UIColor.init(rgb: 0x292929)
            case .White: return UIColor.init(rgb: 0xEAEAE9)
            }
        }
    }
}
final class AppPreference {
    
    //MARK: Shared Instance
    static let sharedInstance : AppPreference = {
        let instance = AppPreference(array: [])
        let tabBarController = UITabBarController.init()
        instance.tabbarHeight = tabBarController.tabBar.frame.size.height
        return instance
    }()
    
    //MARK: Local Variable
    var appBgMode:AppBgMode = .Default {
        didSet{
            NotificationCenter.default.post(name: .appBgMode, object: nil, userInfo: nil)
        }
    }
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
    func getAppBgColor(isDetailVC: Bool = false) -> UIColor{
        if(isDetailVC == false){
            return AppPreference.sharedInstance.appBgMode.bgColor
        }else{
            if(AppPreference.sharedInstance.appBgMode == .Default){
                return AppBgMode.White.bgColor
            }else{
                return AppBgMode.Dark.bgColor
            }
        }
    }
    
    func getNormalCellHeight() -> CGFloat{
        return 50
    }
    func changeNavMode(nav: UINavigationController?){
        if(AppPreference.sharedInstance.appBgMode == .White){
            nav?.navigationBar.barStyle = UIBarStyle.default
        }else{
            nav?.navigationBar.barStyle = UIBarStyle.black
        }
    }
}

extension Notification.Name {
    static let appBgMode = Notification.Name(
        rawValue: "appBgMode")
}
