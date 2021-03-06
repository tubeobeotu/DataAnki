//
//  ContactVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/3/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
import SwipeCellKit
class ContactVC: BaseViewController {
    var arrIndexSection = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var validedArrIndexSection = [String]()
    var contacts = [ContactModel]()
    var filteredContacts = [ContactModel](){
        didSet{
            self.checkValidSections()
        }
    }
    var sections : [Dictionary<String, [ContactModel]>] = []{
        didSet{
            didFilter()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadModels()
        self.tbl_Content?.register(UINib.init(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.tbl_Content?.delegate = self
        self.tbl_Content?.dataSource = self
    }
    override func reloadModels() {
        contacts = AppPreference.sharedInstance.contacts
        filteredContacts = NSMutableArray.init(array: contacts) as? [ContactModel] ?? [ContactModel]()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkValidSections(){
        self.sections.removeAll()
        self.validedArrIndexSection.removeAll()
        for letter in arrIndexSection{
            let tmpContacts = SimpleFunction.filterContacts(input: filteredContacts, beginWith: letter)
            if((tmpContacts?.count ?? 0) > 0){
                self.sections.append([letter : tmpContacts!])
                self.validedArrIndexSection.append(letter)
            }
        }
    }
    
    func didFilter(){
        
    }
    
    @IBAction func addContact(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "EditContactVC") as? EditContactVC{
            vc.contact = ContactModel()
            vc.isNew = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
extension ContactVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppPreference.sharedInstance.getNormalCellHeight()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let contacts = self.sections[indexPath.section].values.first{
            self.showContactDetailVC(contact: contacts[indexPath.row])
        }
        
    }
}

extension ContactVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.setupHeaderView(text: validedArrIndexSection[section])
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.validedArrIndexSection
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        return index
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].values.first?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        if let tmpContacts = self.sections[indexPath.section].values.first
        {
            cell.setModelForCell(contact: tmpContacts[indexPath.row], isHideSubLabel: true, canSelect: !SimpleFunction.checkContactInList(contact: tmpContacts[indexPath.row], contacts: AppPreference.sharedInstance.favouritContacts))
        }
        cell.delegate = self
        return cell
    }
}

extension ContactVC: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let tmpContacts = self.sections[indexPath.section].values.first{
                SimpleFunction.deleteContactToContacts(contact: tmpContacts[indexPath.row])
                SimpleFunction.deleteContactFromSystem(contact: tmpContacts[indexPath.row])
                self.reloadModels()
                self.reloadData()
            }
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "ic_trash")
        
        return [deleteAction]
    }
}
