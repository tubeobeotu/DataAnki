//
//  ContactVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/3/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

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
    
}
extension ContactVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppPreference.sharedInstance.getNormalCellHeight()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

extension ContactVC: UITableViewDataSource{
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let tmpView = UIView()
        header.addSubview(tmpView)
        tmpView.translatesAutoresizingMaskIntoConstraints = false
        let topTmpView = NSLayoutConstraint(item: tmpView, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1, constant: 0)
        let leftTmpView = NSLayoutConstraint(item: tmpView, attribute: .left, relatedBy: .equal, toItem: header, attribute: .left, multiplier: 1, constant: 0)
        let bottomTmpView = NSLayoutConstraint(item: tmpView, attribute: .bottom, relatedBy: .equal, toItem: header, attribute: .bottom, multiplier: 1, constant: 0)
        let rightTmpView = NSLayoutConstraint(item: tmpView, attribute: .right, relatedBy: .equal, toItem: header, attribute: .right, multiplier: 1, constant: 0)
        header.addConstraints([topTmpView, leftTmpView, bottomTmpView, rightTmpView])
        tmpView.backgroundColor = AppPreference.sharedInstance.appBgMode.sectionBgColor
        tmpView.alpha = 0.3
        
        let label = UILabel()
        label.text = validedArrIndexSection[section]
        label.textColor = AppPreference.sharedInstance.appBgMode.sectionTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(label)
        let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: header, attribute: .left, multiplier: 1, constant: 16)
        let bottom = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: header, attribute: .bottom, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: header, attribute: .right, multiplier: 1, constant: -16)
        header.addConstraints([top, left, bottom, right])
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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
        return cell
    }
}
