//
//  BirthdayVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/3/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
import SwipeCellKit
class BirthdayVC: BaseViewController {
    var birthDayContacts = [ContactModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadModels()
        self.tbl_Content?.register(UINib.init(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.tbl_Content?.delegate = self
        self.tbl_Content?.dataSource = self
    }
    override func reloadModels() {
        birthDayContacts = AppPreference.sharedInstance.birthdayContacts
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension BirthdayVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppPreference.sharedInstance.getNormalCellHeight()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showContactDetailVC(contact: birthDayContacts[indexPath.row])
    }
}

extension BirthdayVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.birthDayContacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.setModelForCell(contact: self.birthDayContacts[indexPath.row], isHideSubLabel: false)
        cell.delegate = self
        return cell
    }
}
extension BirthdayVC: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            SimpleFunction.deleteContactToBirthDay(contact: self.recentsContacts[indexPath.row])
            self.birthDayContacts.remove(at: indexPath.row)
            self.reloadModels()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "ic_trash")
        
        return [deleteAction]
    }
}
