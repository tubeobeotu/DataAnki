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
    case Dark = 0
    case White = 1
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
    var appBgMode:AppBgMode = .White {
        didSet{
            NotificationCenter.default.post(name: .appBgMode, object: nil, userInfo: nil)
        }
    }
    var emptyStringArray : [String]
    var tabbarHeight:CGFloat = 0
    let searchViewHeight:CGFloat = 40
    //MARK: Init
    
    init( array : [String]) {
        emptyStringArray = array
    }
    
    func getAppTitleColor() -> UIColor{
        if(AppPreference.sharedInstance.appBgMode == .White){
            return UIColor.black
        }else{
            return UIColor.white
        }
    }
    func getAppBgColor() -> UIColor{
        if(AppPreference.sharedInstance.appBgMode == .White){
            return UIColor.init(rgb: 0xF5F8F8)
        }else{
            return UIColor.black
        }
    }
    func getSubTitleColor() -> UIColor{
        return UIColor.lightGray
    }
    func getBgColorCell() -> UIColor{
        return UIColor.init(rgb: 0xEBEBF1)
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
