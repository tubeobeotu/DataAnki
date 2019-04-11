//
//  EditContactVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
import Contacts
class EditContactVC: BaseViewController {
    var contact:ContactModel!
    var barButtonSave: UIBarButtonItem!
    @IBOutlet weak var v_Avatar: AvatarView!
    
    @IBOutlet weak var cst_StackHeigh: NSLayoutConstraint!
    @IBOutlet weak var v_Organization: UIView!
    
    @IBOutlet weak var lbl_Company: UILabel!
    @IBOutlet weak var btn_Edit: UIButton!
    
    @IBOutlet weak var tf_CompanyName: UITextField!
    
    @IBOutlet weak var tf_FirstName: UITextField!
    @IBOutlet weak var tf_LastName: UITextField!
    
    @IBOutlet weak var switch_CompanyMode: UISwitch!
    var enableCompanyModeHeight:CGFloat = 0
    var photoManager = PhotoManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoManager.delegate = self
        self.v_Avatar.delegate = self
        self.enableCompanyModeHeight = self.cst_StackHeigh.constant
        self.isShowLargeTitle = false
        self.isShowSiriView = false
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAction))
        barButtonSave = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveAction))
//        barButtonSave.isEnabled = false
        self.navigationItem.rightBarButtonItem = barButtonSave
        self.enableCompanyModeUI(enable: contact.contactType == 1)
        
        self.tbl_Content.register(UINib.init(nibName: "ContactNewCell", bundle: nil), forCellReuseIdentifier: "ContactNewCell")
        self.tbl_Content.register(UINib.init(nibName: "ContactEditCell", bundle: nil), forCellReuseIdentifier: "ContactEditCell")
        
        self.v_Avatar.setStateColor(color: contact.stateColor)
        self.v_Avatar.lbl_Name.text = contact.shortName
        self.tf_FirstName.text = contact.firstName
        self.tf_LastName.text = contact.lastName
        self.tf_CompanyName.text = contact.organizationName
        
        contact.firstName = contact.firstName
    }
    
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func saveAction(){
        SimpleFunction.saveContact(contact: contact)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
    }
    func enableCompanyModeUI(enable: Bool){
        if(!enable){
            self.v_Organization.isHidden = true
            self.cst_StackHeigh.constant = self.cst_StackHeigh.constant - self.v_Organization.frame.height
        }else{
            self.v_Organization.isHidden = false
            self.cst_StackHeigh.constant = enableCompanyModeHeight
        }
    }
    
    @IBAction func changeCompanyMode(_ sender: UISwitch) {
        self.enableCompanyModeUI(enable: sender.isOn)
    }
    @IBAction func editPhoto(_ sender: Any) {
        self.didAppAvatar()
    }
    
}


extension EditContactVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let type = ContactModelSectionsType(rawValue: section)
        header.setupHeaderView(text: type?.text.uppercased() ?? "")
        return header
    }
    
}
extension EditContactVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.contact.sectionsAvaiable().count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = ContactModelSectionsType(rawValue: section)!
        switch type {
        case .mobile:
            return self.contact.phoneNumbers.count
        case .email:
            return self.contact.emailAddresses.count
        case .address:
            return self.contact.postalAddresses.count
        case .birthday, .note:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = ContactModelSectionsType(rawValue: indexPath.section)!
        if(type != .address){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailCell", for: indexPath) as! ContactDetailCell
            if(type == .birthday){
                let model = self.contact
                cell.setup(title: type.text, content: model!.getBirthdayString(), isFirst: indexPath.row == 0)
            }else if(type == .email){
                let model = self.contact.emailAddresses[indexPath.row]
                cell.setup(title: model.label, content: model.value, isFirst: indexPath.row == 0)
            }else if(type == .mobile){
                let model = self.contact.phoneNumbers[indexPath.row]
                cell.setup(title: model.label, content: model.value, isFirst: indexPath.row == 0)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
            cell.setupModel(address: self.contact.postalAddresses[indexPath.row])
            return cell
        }
    }
    
}
extension EditContactVC: AvatarViewDelegate{
    func didAppAvatar() {
        self.photoManager.showOptions()
    }
    
    
}
extension EditContactVC : PhotoManagerDelegate
{
    func didSelectImage(image: UIImage) {
        self.v_Avatar.setImage(image: image)
        self.contact.thumbnailImageData = UIImagePNGRepresentation(image)

    }
    
    func didSelectImages(images: [Image]) {
        
    }
    
    func presentVC() -> UIViewController {
        return self
    }
}
