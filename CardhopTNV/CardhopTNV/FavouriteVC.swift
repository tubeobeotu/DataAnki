//
//  FavouriteVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/3/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class FavouriteVC: BaseViewController {
    var favouritedContacts = [ContactModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadModels()
        self.tbl_Content?.register(UINib.init(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.tbl_Content?.delegate = self
        self.tbl_Content?.dataSource = self
    }
    override func reloadModels() {
        favouritedContacts = AppPreference.sharedInstance.favouritContacts
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showSearchingVC(_ sender: Any) {
        self.showSearchingVC(isShowGuide: false)
        
    }
    @IBAction func editMode(_ sender: Any) {
    }
    
    override func didSelectContactAtVC(contact: ContactModel) {
        SimpleFunction.insertContactToFavourit(contact: contact)
    }
    
}
extension FavouriteVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppPreference.sharedInstance.getNormalCellHeight()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showContactDetailVC(contact: favouritedContacts[indexPath.row])
    }
    
}

extension FavouriteVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favouritedContacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.setModelForCell(contact: self.favouritedContacts[indexPath.row], isHideSubLabel: true)
        return cell
    }
}
