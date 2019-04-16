//
//  AppDelegate.swift
//  CardhopTNV
//
//  Created by Tu on 4/3/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
import DropDown
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        DropDown.startListeningToKeyboard()
        SimpleFunction.getContacts()
        SimpleFunction.getSettingsFromLocal()
        AppPreference.sharedInstance.siriView = SearchingView.init()
        AppPreference.sharedInstance.siriView.viewType = .UnAction
//        AppPreference.sharedInstance.siriView.frame = CGRect(x: 8, y: UIScreen.main.bounds.height - AppPreference.sharedInstance.searchViewHeight-AppPreference.sharedInstance.tabbarHeight - AppPreference.sharedInstance.marginSearchView, width: UIScreen.main.bounds.width - 8*2, height: AppPreference.sharedInstance.searchViewHeight)
        //window?.willRemoveSubview(view)
        window?.makeKeyAndVisible()
        window?.insertSubview(AppPreference.sharedInstance.siriView, at: 0)
        window?.bringSubview(toFront: AppPreference.sharedInstance.siriView)
        var bottomPadding:CGFloat = 0
        if #available(iOS 11.0, *) {
            bottomPadding = window?.safeAreaInsets.bottom ?? 0
        }
        
        let tmpView = AppPreference.sharedInstance.siriView!
        tmpView.translatesAutoresizingMaskIntoConstraints = false
        let heightTmpView = NSLayoutConstraint(item: tmpView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: AppPreference.sharedInstance.searchViewHeight)
        let leftTmpView = NSLayoutConstraint(item: tmpView, attribute: .left, relatedBy: .equal, toItem: window, attribute: .left, multiplier: 1, constant: 8)
        let bottomTmpView = NSLayoutConstraint(item: tmpView, attribute: .bottom, relatedBy: .equal, toItem: window, attribute: .bottom, multiplier: 1, constant: -(AppPreference.sharedInstance.tabbarHeight + AppPreference.sharedInstance.marginSearchView + bottomPadding))
        let rightTmpView = NSLayoutConstraint(item: tmpView, attribute: .right, relatedBy: .equal, toItem: window, attribute: .right, multiplier: 1, constant: -8)
        window?.addConstraints([heightTmpView, leftTmpView, bottomTmpView, rightTmpView])
        
        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = UIColor.clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        ContactFileManager.saveContacts()
        ContactFileManager.saveSettings()
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        SimpleFunction.getContacts()
        SimpleFunction.getSettingsFromLocal()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

