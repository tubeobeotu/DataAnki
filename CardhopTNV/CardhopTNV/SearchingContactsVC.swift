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
    var isShowGuide = false
    @IBOutlet weak var sb_Contacts: UISearchBar!
    @IBOutlet weak var v_Guide: SearchingGuideView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowSiriView = false
        self.sb_Contacts.textField?.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.v_Guide.isHidden = !self.isShowGuide
        self.sb_Contacts.delegate = self
        self.reloadModels()
        self.tbl_Content?.register(UINib.init(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.tbl_Content?.delegate = self
        self.tbl_Content?.dataSource = self
        self.checkShowGuide(isShow: isShowGuide)
    }
    func checkShowGuide(isShow: Bool){
        self.v_Guide?.isHidden = !isShow
        self.tbl_Content?.isHidden = isShow
    }

    override func reloadModels() {
        contacts = AppPreference.sharedInstance.contacts
        if(self.isShowGuide){
            self.filteredContacts = [ContactModel]()
        }else{
            self.filteredContacts = NSMutableArray.init(array: contacts) as? [ContactModel] ?? [ContactModel]()
        }
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
    
    override func didFilter(){
        if(self.isShowGuide){
            if(self.sections.count == 0){
                self.checkShowGuide(isShow: true)
            }else{
                self.checkShowGuide(isShow: false)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.isShowGuide){
            self.showContactDetailVC(contact: self.filteredContacts[indexPath.row])
        }else{
            if let tmpContacts = self.sections[indexPath.section].values.first
            {
                if(!(SimpleFunction.checkContactInList(contact: tmpContacts[indexPath.row], contacts: AppPreference.sharedInstance.favouritContacts))){
                    self.delegate?.didSelectContact(contact: tmpContacts[indexPath.row])
                    self.closeVC()
                }
                
            }
            
            
            
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
        if(self.isShowGuide){
            self.filteredContacts = [ContactModel]()
        }else{
            self.filteredContacts = NSMutableArray.init(array: contacts) as? [ContactModel] ?? [ContactModel]()
        }
        
        self.reloadData()
    }
}

