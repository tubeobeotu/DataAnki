//
//  SettingDetailVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/10/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
enum SortBy:String{
    case FirstNameLastName = "0"
    case LastNameFirstName = "1"
    var title: String{
        get{
            switch(self){
            case .FirstNameLastName: return "First Name, Last Name"
            case .LastNameFirstName: return "Last Name, First Name"
                
            }
        }
    }
}
enum DisplayName:String{
    case FistLast = "0"
    case LastFirst = "1"
    case LastFirst2 = "2"
    var title: String{
        get{
            switch(self){
            case .FistLast: return "First Last (John Doe)"
            case .LastFirst: return "Last First (Doe John)"
            case .LastFirst2: return "Last, First (Doe, John)"
            }
        }
    }
}
class SettingDetailVC: BaseViewController {
    var type:OptionIndexType = .SortBy{
        didSet{
            self.title = type.title
        }
    }
    
    let sortBy:[SortBy] = [.FirstNameLastName, .LastNameFirstName]
    let display:[DisplayName] = [.FistLast, .LastFirst, .LastFirst2]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tbl_Content.delegate = self
        self.tbl_Content.dataSource = self
        self.tbl_Content.register(UINib.init(nibName: "SettingNormalCell", bundle: nil), forCellReuseIdentifier: "SettingNormalCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppPreference.sharedInstance.siriView.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppPreference.sharedInstance.siriView.isHidden = false
    }

}
extension SettingDetailVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(type == .SortBy){
            AppPreference.sharedInstance.settings.sortType = sortBy[indexPath.row]
        }else{
            AppPreference.sharedInstance.settings.displayName = display[indexPath.row]
        }
        self.reloadData()
    }
}
extension SettingDetailVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type == .SortBy ? sortBy.count : display.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingNormalCell", for: indexPath) as? SettingNormalCell
        cell?.lbl_Title.text = type == .SortBy ? sortBy[indexPath.row].title : display[indexPath.row].title
        cell?.accessoryType = .none
        if(type == .SortBy){
            if(AppPreference.sharedInstance.settings.sortType == sortBy[indexPath.row]){
                cell?.accessoryType = .checkmark
            }
        }else{
            if(AppPreference.sharedInstance.settings.displayName == display[indexPath.row]){
                cell?.accessoryType = .checkmark
            }
        }
        return cell!
    }
    
    
}
