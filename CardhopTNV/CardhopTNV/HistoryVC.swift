//
//  HistoryVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/3/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class HistoryVC: BaseViewController {
    var recentsContacts = [ContactModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadModels()
        self.tbl_Content?.register(UINib.init(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.tbl_Content?.delegate = self
        self.tbl_Content?.dataSource = self
    }
    override func reloadModels() {
        recentsContacts = AppPreference.sharedInstance.recentContacts
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension HistoryVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppPreference.sharedInstance.getNormalCellHeight()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showContactDetailVC(contact: recentsContacts[indexPath.row])
    }
}

extension HistoryVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentsContacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.setModelForCell(contact: self.recentsContacts[indexPath.row], isHideSubLabel: false)
        return cell
    }
}
