//
//  SearchingContactsVC.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/9/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
protocol SearchingContactsVCDelegate{
    func didSelectContact(contact: ContactModel)
}
class SearchingContactsVC: ContactVC {
    var delegate:SearchingContactsVCDelegate?
    @IBOutlet weak var sb_Contacts: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sb_Contacts.delegate = self
        self.reloadModels()
        self.tbl_Content?.register(UINib.init(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.tbl_Content?.delegate = self
        self.tbl_Content?.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppPreference.sharedInstance.siriView.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppPreference.sharedInstance.siriView.isHidden = false
    }
    
    override func reloadModels() {
        contacts = AppPreference.sharedInstance.contacts
        self.filteredContacts = NSMutableArray.init(array: contacts) as? [ContactModel] ?? [ContactModel]()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        self.closeVC()
    }
    
    func closeVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!(SimpleFunction.checkContactInList(contact: self.filteredContacts[indexPath.row], contacts: AppPreference.sharedInstance.favouritContacts))){
            self.delegate?.didSelectContact(contact: self.filteredContacts[indexPath.row])
            self.closeVC()
        }
    }
    
}
extension SearchingContactsVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isValidedString()){
            self.filteredContacts = SimpleFunction.filterContacts(input: NSMutableArray.init(array: self.contacts) as? Array<ContactModel> ?? [ContactModel](), keyword: searchText) ?? [ContactModel]()
            self.reloadData()
        }else{
            self.showAllContacts()
        }
        
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showAllContacts()
    }
    
    func showAllContacts(){
        self.filteredContacts = NSMutableArray.init(array: contacts) as? [ContactModel] ?? [ContactModel]()
        self.reloadData()
    }
}

