//
//  ContactCountryVC.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/10/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class ContactCountryVC: BaseViewController {
    var isSelectType:OptionIndexType = .AddressFormat{
        didSet{
            self.title = isSelectType.title
        }
    }
    var arrIndexSection = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var validedArrIndexSection = [String]()
    var sections : [Dictionary<String, [CountryModel]>] = []{
        didSet{
           
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowLargeTitle = false
        self.isShowSiriView = false
        self.checkValidSections()
        self.tbl_Content.delegate = self
        self.tbl_Content.dataSource = self
        self.tbl_Content.register(UINib.init(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
        // Do any additional setup after loading the view.
    }
    
    
    func checkValidSections(){
        self.sections.removeAll()
        self.validedArrIndexSection.removeAll()
        for letter in arrIndexSection{
            let tmpContacts = AppPreference.sharedInstance.countries.filter { (country) -> Bool in
                return country.name.contains(letter)
            }
            if(tmpContacts.count > 0){
                self.sections.append([letter : tmpContacts])
                self.validedArrIndexSection.append(letter)
            }
        }
    }
}

extension ContactCountryVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let country = self.sections[indexPath.section].values.first{
            if(self.isSelectType == .AddressFormat){
                AppPreference.sharedInstance.settings.addressFormat = country[indexPath.row].code
                
            }else{
                AppPreference.sharedInstance.settings.defaultCountryCode = country[indexPath.row].code
            }
        }
        self.reloadData()
        

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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.setupHeaderView(text: validedArrIndexSection[section])
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(self.isSelectType == .AddressFormat){
            return 40
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
extension ContactCountryVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].values.first?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        if let country = self.sections[indexPath.section].values.first
        {
            cell.type = self.isSelectType
            cell.setupCountry(country: country[indexPath.row])
            cell.accessoryType = .none
            if(self.isSelectType == .AddressFormat){
                if(country[indexPath.row].code == AppPreference.sharedInstance.settings.addressFormat){
                    cell.accessoryType = .checkmark
                }
                
            }else{
                if(country[indexPath.row].code == AppPreference.sharedInstance.settings.defaultCountryCode){
                    cell.accessoryType = .checkmark
                }
            }
            
        }
        return cell
    }
}

