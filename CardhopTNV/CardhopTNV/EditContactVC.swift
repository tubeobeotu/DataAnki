//
//  EditContactVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
import Contacts
import DropDown
class EditContactVC: BaseViewController {
    var contact:ContactModel!
    var isNew = false
    var barButtonSave: UIBarButtonItem!
    @IBOutlet weak var v_Avatar: AvatarView!
    
    @IBOutlet weak var cst_StackHeigh: NSLayoutConstraint!
    @IBOutlet weak var v_Organization: UIView!
    
    @IBOutlet weak var lbl_Company: UILabel!
    @IBOutlet weak var btn_Edit: UIButton!
    
    @IBOutlet weak var tf_CompanyName: UITextField!
    
    @IBOutlet weak var tf_FirstName: UITextField!
    @IBOutlet weak var tf_LastName: UITextField!
    
    @IBOutlet weak var dp_Birthday: UIDatePicker!
    @IBOutlet weak var switch_CompanyMode: UISwitch!
    @IBOutlet weak var v_DatePicker: UIView!
    
    @IBOutlet weak var btn_buildingIcon: UIButton!
    let dropDownPhone = DropDown()
    let dropDownEmail = DropDown()
    let dropDownAddress = DropDown()
    
    var listEmailLabel = [ContactLabelModel]()
    var listPhoneLabel = [ContactLabelModel]()
    var listAddressLabel = [ContactLabelModel]()
    
    var enableCompanyModeHeight:CGFloat = 0
    var photoManager = PhotoManager()
    
    var currentSelectedIndexCell:IndexPath?
    override func viewDidLoad() {
        if(AppPreference.sharedInstance.settings.appBgMode == .Default){
            AppPreference.sharedInstance.isDetailVC = true
        }
        super.viewDidLoad()
        self.v_DatePicker.isHidden = true
        self.photoManager.delegate = self
        self.v_Avatar.delegate = self
        self.enableCompanyModeHeight = self.cst_StackHeigh.constant
        self.isShowLargeTitle = false
        self.isShowSiriView = false
        self.btn_buildingIcon.tintColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        barButtonSave = UIBarButtonItem(title: isNew == false ? "Save" : "Add", style: .done, target: self, action: #selector(saveAction))
//        barButtonSave.isEnabled = false
        self.navigationItem.rightBarButtonItem = barButtonSave
        self.enableCompanyModeUI(enable: contact.contactType == 1)
        
        self.tbl_Content.register(UINib.init(nibName: "ContactNewCell", bundle: nil), forCellReuseIdentifier: "ContactNewCell")
        self.tbl_Content.register(UINib.init(nibName: "ContactEditCell", bundle: nil), forCellReuseIdentifier: "ContactEditCell")
        self.tbl_Content.register(UINib.init(nibName: "ContactNoteCell", bundle: nil), forCellReuseIdentifier: "ContactNoteCell")
        self.tbl_Content.register(UINib.init(nibName: "AddressEditCell", bundle: nil), forCellReuseIdentifier: "AddressEditCell")
        
        
        self.tbl_Content.delegate = self
        self.tbl_Content.dataSource = self
        
        self.v_Avatar.setStateColor(color: contact.stateColor)
        self.v_Avatar.lbl_Name.text = contact.shortName
        if let picture = self.contact.thumbnailImageData{
            self.v_Avatar.setImage(image: UIImage(data: picture, scale: 1.0) )
        }
        
        self.tf_FirstName.text = contact.firstName
        self.tf_LastName.text = contact.lastName
        self.tf_CompanyName.text = contact.organizationName
        
        self.tf_FirstName.delegate = self
        self.tf_LastName.delegate = self
        self.tf_CompanyName.delegate = self
        
        
        self.tf_FirstName.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.tf_LastName.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.tf_CompanyName.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.lbl_Company.textColor = self.tf_FirstName.textColor
        
        self.tf_FirstName.attributedPlaceholder = NSAttributedString(string: self.tf_FirstName.placeholder ?? "",
                                                               attributes: [.foregroundColor: AppPreference.sharedInstance.settings.appBgMode.sectionTextColor])
        self.tf_LastName.attributedPlaceholder = NSAttributedString(string: self.tf_LastName.placeholder ?? "",
                                                                     attributes: [.foregroundColor: AppPreference.sharedInstance.settings.appBgMode.sectionTextColor])
        self.tf_CompanyName.attributedPlaceholder = NSAttributedString(string: self.tf_CompanyName.placeholder ?? "",
                                                                     attributes: [.foregroundColor: AppPreference.sharedInstance.settings.appBgMode.sectionTextColor])
        
        contact.firstName = contact.firstName
        self.getListEmailLabels()
        self.getListAddresLabels()
        self.getListPhoneLabels()
        self.setupDropDowns()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(AppPreference.sharedInstance.settings.appBgMode == .Default){
            AppPreference.sharedInstance.isDetailVC = true
        }
    }
    func getListAddresLabels(){
        self.listAddressLabel.removeAll()
        for label in SimpleFunction.getListAddressesLabels(){
            let tmpLabel = ContactLabelModel()
            tmpLabel.label = label
            self.listAddressLabel.append(tmpLabel)
        }
    }
    func getListEmailLabels(){
        self.listEmailLabel.removeAll()
        for label in SimpleFunction.getListEmailLabels(){
            let tmpLabel = ContactLabelModel()
            tmpLabel.label = label
            self.listEmailLabel.append(tmpLabel)
        }
    }
    func getListPhoneLabels(){
        self.listPhoneLabel.removeAll()
        for label in SimpleFunction.getListNumberLabels(){
            let tmpLabel = ContactLabelModel()
            tmpLabel.label = label
            self.listPhoneLabel.append(tmpLabel)
        }
    }
    func setupDropDowns(){
        self.dropDownAddress.dataSource = self.listAddressLabel.map({ (label) -> String in
            return label.label
        })
        self.dropDownAddress.selectionAction = { [unowned self] (index: Int, item: String) in
            if let indexPath = self.currentSelectedIndexCell{
                self.contact.postalAddresses[indexPath.row].label = self.listAddressLabel[index].label
                self.barButtonSave.isEnabled = true
                self.tbl_Content.reloadRows(at: [indexPath], with: .none)
            }
            
        }
        
        
        self.dropDownEmail.dataSource = self.listEmailLabel.map({ (label) -> String in
            return label.label
        })
        self.dropDownEmail.selectionAction = { [unowned self] (index: Int, item: String) in
            if let indexPath = self.currentSelectedIndexCell{
                self.contact.emailAddresses[indexPath.row].label = self.listEmailLabel[index].label
                self.barButtonSave.isEnabled = true
                self.tbl_Content.reloadRows(at: [indexPath], with: .none)
            }
            
        }
        self.dropDownPhone.dataSource = self.listPhoneLabel.map({ (label) -> String in
            return label.label
        })
        self.dropDownPhone.selectionAction = { [unowned self] (index: Int, item: String) in
            if let indexPath = self.currentSelectedIndexCell{
                self.contact.phoneNumbers[indexPath.row].label = self.listPhoneLabel[index].label
                self.barButtonSave.isEnabled = true
                self.tbl_Content.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveAction(){
        self.contact.firstName = tf_FirstName.text ?? ""
        self.contact.lastName = tf_LastName.text ?? ""
        self.contact.organizationName = tf_CompanyName.text ?? ""
        if(isNew == false){
            SimpleFunction.saveContact(contact: contact)
        }else{
            SimpleFunction.addContact(contact: contact)
        }
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
    }
    func enableCompanyModeUI(enable: Bool){
        self.switch_CompanyMode.isOn = enable
        if(!enable){
            self.contact.contactType = 0
            self.v_Organization.isHidden = true
            self.cst_StackHeigh.constant = self.cst_StackHeigh.constant - self.v_Organization.frame.height
        }else{
            self.contact.contactType = 1
            self.v_Organization.isHidden = false
            self.cst_StackHeigh.constant = enableCompanyModeHeight
        }
    }
    
    @IBAction func didSelectDoneDatePicker(_ sender: Any) {
        self.didSelectBirthday()
    }
    @IBAction func changeCompanyMode(_ sender: UISwitch) {
        barButtonSave.isEnabled = true
        self.enableCompanyModeUI(enable: sender.isOn)
    }
    @IBAction func editPhoto(_ sender: Any) {
        self.didAppAvatar()
    }
    
    @objc func didSelectBirthday(){
        self.v_DatePicker.isHidden = true
        self.contact.birthday = self.dp_Birthday.date.dateComponents
        self.barButtonSave.isEnabled = true
        self.tbl_Content.reloadSections(IndexSet.init(integer: ContactModelSectionsType.birthday.rawValue), with: .none)
    }
    
    override func didTapToView() {
        self.v_DatePicker.isHidden = true
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
        return 4 + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = ContactModelSectionsType(rawValue: section)!
        switch type {
        case .mobile:
            return self.contact.phoneNumbers.count + 1
        case .email:
            return self.contact.emailAddresses.count + 1
        case .address:
            return self.contact.postalAddresses.count + 1
        case .birthday, .note:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = ContactModelSectionsType(rawValue: indexPath.section)!
        if(type == .note){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactNoteCell", for: indexPath) as! ContactNoteCell
            cell.tv_Content.text = self.contact.note
            return cell
        }else{
            if(type != .address){
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactEditCell", for: indexPath) as! ContactEditCell
                cell.delegate = self
                cell.type = type
                if(type == .birthday){
                    let model = self.contact
                    cell.setup(title: type.text, content: model!.getBirthdayString(), isFirst: indexPath.row == 0)
                }else if(type == .email){
                    if(indexPath.row == self.contact.emailAddresses.count){
                        let newCell = tableView.dequeueReusableCell(withIdentifier: "ContactNewCell", for: indexPath) as! ContactNewCell
                        newCell.delegate = self
                        newCell.type = .email
                        return newCell
                    }
                    let model = self.contact.emailAddresses[indexPath.row]
                    cell.setup(title: model.label, content: model.value, isFirst: indexPath.row == 0)
                    if(indexPath.row == self.contact.emailAddresses.count - 1 && model.isNew){
                        cell.becomeFirstResponderCell()
                    }
                }else if(type == .mobile){
                    if(indexPath.row == self.contact.phoneNumbers.count){
                        let newCell = tableView.dequeueReusableCell(withIdentifier: "ContactNewCell", for: indexPath) as! ContactNewCell
                        newCell.delegate = self
                        newCell.type = .phone
                        return newCell
                    }
                    let model = self.contact.phoneNumbers[indexPath.row]
                    cell.setup(title: model.label, content: model.value, isFirst: indexPath.row == 0)
                    if(indexPath.row == self.contact.phoneNumbers.count - 1 && model.isNew){
                        cell.becomeFirstResponderCell()
                    }
                }
                return cell
            }else{
                if(indexPath.row == self.contact.postalAddresses.count){
                    let newCell = tableView.dequeueReusableCell(withIdentifier: "ContactNewCell", for: indexPath) as! ContactNewCell
                    newCell.delegate = self
                    newCell.type = .address
                    return newCell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddressEditCell", for: indexPath) as! AddressEditCell
                cell.setupModel(address: self.contact.postalAddresses[indexPath.row])
                cell.delegate = self
                return cell
            }
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

extension EditContactVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            self.barButtonSave.isEnabled = updatedText.isValidedString()
        }else{
            self.barButtonSave.isEnabled = false
        }
        
        return true
    }
}
extension EditContactVC: ContactNoteCellDelegate{
    func didChangeNote(content: String){
        self.btn_Edit.isEnabled = true
        self.contact.note = content
    }
    func changeNote(content: String, cell: UITableViewCell) {
        tbl_Content.beginUpdates()
        let index = self.tbl_Content.indexPath(for: cell)
        tbl_Content.reloadRows(at: [index!], with: .none)
        tbl_Content.endUpdates()
    }
    func beginEditCell(cell: ContactEditCell, type: ContactModelSectionsType) {
        if(type == .birthday){
            self.v_DatePicker.isHidden = false
        }
    }
    func changeValue(cell: ContactEditCell, type: ContactModelSectionsType, value: String) {
        if let indexPath = self.tbl_Content.indexPath(for: cell){
            switch(type){
            case .email:
                let model = self.contact.emailAddresses[indexPath.row]
                model.value = value
                break
            case .mobile:
                let model = self.contact.phoneNumbers[indexPath.row]
                model.value = value
                break
            case .note:
                self.contact.note = value
                break
            default:
                break
            }
        }
        
    }
}
extension EditContactVC: AddressEditCellDelegate{
    func didSelectAddressDropDown(cell: AddressEditCell) {
        currentSelectedIndexCell = self.tbl_Content.indexPath(for: cell)
        self.dropDownAddress.anchorView = cell.btn_DropDown
        self.dropDownAddress.show()
    }
    func didSelectRemoveDropDown(cell: AddressEditCell) {
        currentSelectedIndexCell = self.tbl_Content.indexPath(for: cell)
        if let indexPath = self.tbl_Content.indexPath(for: cell){
            self.contact.postalAddresses.remove(at: indexPath.row)
        }
        self.reloadData()
    }
    func changeAddressValue(cell: AddressEditCell, type: AddressType, value: String) {
        if let indexPath = self.tbl_Content.indexPath(for: cell){
            let model = self.contact.postalAddresses[indexPath.row]
            switch(type){
            case .city:
                model.city = value
                break
            case .country:
                model.country = value
                break
            case .postCode:
                model.postalCode = value
                break
            case .province:
                model.state = value
                break
            case .street:
                model.street = value
                break
            }
        }
        
    }
}

extension EditContactVC: ContactNewCellDelegate{
    func didTapAddNew(type: ContactNewCellType) {
        if(type == .email){
            let email = ContactLabelModel()
            let firstLabel = SimpleFunction.getListEmailLabels().first
            email.isEmail = true
            email.label = firstLabel ?? "Other"
            email.isNew = true
            self.contact.emailAddresses.append(email)
        }else if(type == .phone){
            let phone = ContactLabelModel()
            let firstLabel = SimpleFunction.getListNumberLabels().first
            phone.isEmail = false
            phone.isNew = true
            phone.label = firstLabel ?? "Other"
            self.contact.phoneNumbers.append(phone)
        }else{
            let tmpAddress = ContactAddressModel()
            let firstLabel = SimpleFunction.getListAddressesLabels().first
            tmpAddress.label = firstLabel ?? "Other"
            self.contact.postalAddresses.append(tmpAddress)
        }
        self.reloadData()
    }
}

extension EditContactVC: ContactEditCellDelegate{
    func didSelectDelete(cell: ContactEditCell) {
        currentSelectedIndexCell = self.tbl_Content.indexPath(for: cell)
        if let indexPath = self.tbl_Content.indexPath(for: cell){
            let type = ContactModelSectionsType(rawValue: indexPath.section)!
            if(type == .email){
                self.contact.emailAddresses.remove(at: indexPath.row)
            }else if(type == .mobile){
                self.contact.phoneNumbers.remove(at: indexPath.row)
            }
            self.barButtonSave.isEnabled = true
            self.tbl_Content.reloadSections(IndexSet.init(integer: indexPath.section), with: .none)
        }
    }
    func didSelectDropDown(cell: ContactEditCell) {
        currentSelectedIndexCell = self.tbl_Content.indexPath(for: cell)
        if let indexPath = self.tbl_Content.indexPath(for: cell){
            let type = ContactModelSectionsType(rawValue: indexPath.section)!
            if(type == .email){
                self.dropDownEmail.anchorView = cell.btn_DropList
                self.dropDownEmail.show()
            }else if(type == .mobile){
                self.dropDownPhone.anchorView = cell.btn_DropList
                self.dropDownPhone.show()
            }
        }
        
    }
}
