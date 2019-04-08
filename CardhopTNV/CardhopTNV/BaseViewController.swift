//
//  BaseViewController.swift
//  CardhopTNV
//
//  Created by Tu on 4/3/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    @IBOutlet weak var tbl_Content: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationItem.largeTitleDisplayMode = .always
        }
        self.tbl_Content?.separatorStyle = .none
        self.tbl_Content?.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    
        self.changeBgView()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(changeBgView),
                                       name: .appBgMode,
                                       object: nil)
        let aa = SimpleFunction.getContacts()
        
        print("")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func changeBgView(){
        self.view.backgroundColor = AppPreference.sharedInstance.getAppBgColor()
        AppPreference.sharedInstance.changeNavMode(nav: self.navigationController)
        self.reloadData()
    }
    
    func reloadData(){
        self.tbl_Content.reloadData()
    }
    
}
