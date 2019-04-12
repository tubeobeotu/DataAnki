//
//  ContactDetailVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
import DropDown
class ContactDetailVC: BaseViewController {
    @IBOutlet weak var v_Avatar: AvatarView!
    
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var v_Message: ContactActionDetailView!
    
    @IBOutlet weak var v_Email: ContactActionDetailView!
    
    @IBOutlet weak var v_Call: ContactActionDetailView!
    
    @IBOutlet weak var v_Video: ContactActionDetailView!
    @IBOutlet weak var cst_Top: NSLayoutConstraint!
    
    @IBOutlet weak var v_Birthday: UIView!
    @IBOutlet weak var cst_BirthdayHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_Birthday: UILabel!
    var contact:ContactModel!
    var photoManager = PhotoManager()
    var btnPhoto:UIButton!
    var phoneNumber = ""
    var emailAddress = ""
    let dropDownPhone = DropDown()
    let dropDownEmail = DropDown()
    
    var currentType:ActionType = .Message
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoManager.delegate = self
        
        let topBarHeight =
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        self.cst_Top.constant = -topBarHeight
        self.isShowLargeTitle = false
        self.isShowSiriView = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(showEditVC))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAction))
        
        self.v_Avatar.delegate = self
        self.v_Avatar.setStateColor(color: contact.stateColor)
        self.v_Avatar.lbl_Name.text = contact.shortName
        if let picture = self.contact.thumbnailImageData{
            self.v_Avatar.setImage(image: UIImage(data: picture, scale: 1.0) )
        }
        
        self.lbl_Name.text = contact.displayName
        self.lbl_Name.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.lbl_Birthday.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        
        
        self.tbl_Content.register(UINib.init(nibName: "ContactDetailCell", bundle: nil), forCellReuseIdentifier: "ContactDetailCell")
        self.tbl_Content.register(UINib.init(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
        self.tbl_Content.register(UINib.init(nibName: "ContactNoteCell", bundle: nil), forCellReuseIdentifier: "ContactNoteCell")
        
        self.tbl_Content.delegate = self
        self.tbl_Content.dataSource = self
        
        self.v_Message.type = .Message
        self.v_Message.delegate = self
        self.v_Email.type = .Email
        self.v_Email.delegate = self
        self.v_Call.type = .Call
        self.v_Call.delegate = self
        self.v_Video.type = .Video
        self.v_Video.delegate = self
        
        self.addActionButton()
        self.setupDropDowns()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupBirthdayView()
    }
    func setupDropDowns(){
        self.dropDownPhone.dataSource = self.contact.phoneNumbers.map({ (label) -> String in
            return label.value
        })
        self.dropDownEmail.dataSource = self.contact.emailAddresses.map({ (label) -> String in
            return label.value
        })
        self.dropDownEmail.direction = .bottom
        self.dropDownPhone.direction = .bottom
        
        self.dropDownEmail.selectionAction = { [unowned self] (index: Int, item: String) in
            self.emailAddress = item
            SimpleFunction.sendEmail(email: item, content: "", vc: self)
        }
        self.dropDownPhone.selectionAction = { [unowned self] (index: Int, item: String) in
            self.phoneNumber = item
            if(self.currentType == .Call){
                SimpleFunction.callNumber(phoneNumber: self.contact.phoneNumbers.first?.value ?? "", vc: self)
            }else if(self.currentType == .Message){
                SimpleFunction.sendMessage(phoneNumber: self.contact.phoneNumbers.first?.value ?? "", content: "", vc: self)
            }else{
                SimpleFunction.facetime(phoneNumber: self.contact.phoneNumbers.first?.value ?? "", vc: self)
            }
        }
    }
    func setupBirthdayView(){
        func hide(){
            self.v_Birthday.isHidden = true
            self.cst_BirthdayHeight.constant = 0
        }
        if(self.contact.birthday != nil){
            if let date = NSCalendar.current.date(from: self.contact.birthday!){
                if(Calendar.current.isDateInToday(date)){
                    self.v_Birthday.isHidden = false
                    self.lbl_Birthday.text = "\(self.contact.firstName)'s birthday is today!"
                    self.cst_BirthdayHeight.constant = 25
                    return
                }
            }
        }
        
        
        hide()
        
    }
    @objc func cancelAction(){
        SimpleFunction.calculateContactsFromLocal(contacts: AppPreference.sharedInstance.contacts)
        self.btnPhoto.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
    }
    @objc func showEditVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "EditContactVC") as? EditContactVC{
            vc.contact = self.contact
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func addActionButton(){
        let frame = CGRect.init(x: self.view.center.x - self.v_Avatar.frame.width/2, y: UIApplication.shared.statusBarFrame.height, width: self.v_Avatar.frame.width, height: self.v_Avatar.frame.height)
        btnPhoto = UIButton(frame: frame)
        btnPhoto.setTitle("", for: .normal)
        btnPhoto.addTarget(self, action: #selector(showChosePhoto(_:)), for: .touchUpInside)
        
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(btnPhoto)
    }
    @IBAction func showChosePhoto(_ sender: Any) {
        self.didAppAvatar()
    }
    
}
extension ContactDetailVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
extension ContactDetailVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.contact.sectionsAvaiable().count + 1
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
        if(type == .note){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactNoteCell", for: indexPath) as! ContactNoteCell
            cell.delegate = self
            cell.tv_Content.text = self.contact.note
            return cell
        }else{
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
}

extension ContactDetailVC: AvatarViewDelegate{
    func didAppAvatar() {
        if let photo = self.contact.thumbnailImageData{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "ImageProfileVC") as? ImageProfileVC{
                vc.title = self.contact.firstName
                vc.picture = UIImage(data:photo,scale:1.0) 
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            self.photoManager.showOptions()
        }
        
    }
    
    
}
extension ContactDetailVC : PhotoManagerDelegate
{
    func didSelectImage(image: UIImage) {
        self.v_Avatar.setImage(image: image)
        self.contact.thumbnailImageData = UIImagePNGRepresentation(image)
        SimpleFunction.saveContact(contact: self.contact)
    }

    func didSelectImages(images: [Image]) {
        
    }

    func presentVC() -> UIViewController {
        return self
    }
}
extension ContactDetailVC: ContactNoteCellDelegate{
    func didChangeNote(content: String) {
        self.contact.note = content
        SimpleFunction.saveContactNote(contact: self.contact)
    }
    func changeNote(content: String, cell: UITableViewCell) {
        
    }
}
extension ContactDetailVC: ContactActionDetailViewDelegate{
    func didSelectAction(type: ActionType) {
        currentType = type
        switch type {
        case .Call:
            self.showDropDown(dropDown: dropDownPhone, anchor: v_Call)
        break
        case .Email:
            self.showDropDown(dropDown: dropDownEmail, anchor: v_Email)
        break
        case .Message:
            self.showDropDown(dropDown: dropDownPhone, anchor: v_Message)
        break
        case .Video:
            self.showDropDown(dropDown: dropDownPhone, anchor: v_Video)
        break
        }
    }
    
    func showDropDown(dropDown: DropDown, anchor: UIView){
        dropDown.anchorView = anchor
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! + 8)
        dropDown.show()
    }
}
