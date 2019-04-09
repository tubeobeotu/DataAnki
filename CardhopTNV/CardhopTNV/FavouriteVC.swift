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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nav = storyboard.instantiateViewController(withIdentifier: "NavSearchingContactVC") as? UINavigationController{
            if let controller = nav.viewControllers.first as? SearchingContactsVC{
                controller.delegate = self
                self.present(nav, animated: true, completion: nil)
            }
            
            
        }
        
    }
    @IBAction func editMode(_ sender: Any) {
    }
    
}
extension FavouriteVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppPreference.sharedInstance.getNormalCellHeight()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
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
extension FavouriteVC: SearchingContactsVCDelegate{
    func didSelectContact(contact: ContactModel) {
        SimpleFunction.insertContactToFavourit(contact: contact)
    }
}
