//
//  ContactDetailVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class ContactDetailVC: BaseViewController {
    @IBOutlet weak var v_Avatar: AvatarView!
    
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var v_Message: ContactActionDetailView!
    
    @IBOutlet weak var v_Email: ContactActionDetailView!
    
    @IBOutlet weak var v_Call: ContactActionDetailView!
    
    @IBOutlet weak var v_Video: ContactActionDetailView!
    
    @IBOutlet weak var cst_Top: NSLayoutConstraint!
    
    @IBOutlet weak var cst_BirthdayHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_Birthday: UILabel!
    var contact:ContactModel!
    var photoManager = PhotoManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoManager.delegate = self
        self.v_Avatar.delegate = self
        let topBarHeight =
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        self.cst_Top.constant = -topBarHeight
        self.isShowLargeTitle = false
        self.isShowSiriView = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(showEditVC))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAction))
        
        self.v_Avatar.setStateColor(color: contact.stateColor)
        self.v_Avatar.lbl_Name.text = contact.shortName
        self.lbl_Name.text = contact.displayName
        
        self.tbl_Content.register(UINib.init(nibName: "ContactDetailCell", bundle: nil), forCellReuseIdentifier: "ContactDetailCell")
        self.tbl_Content.register(UINib.init(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
        self.tbl_Content.delegate = self
        self.tbl_Content.dataSource = self
        
        self.v_Message.type = .Message
        self.v_Email.type = .Email
        self.v_Call.type = .Call
        self.v_Video.type = .Video
    }
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func showEditVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "EditContactVC") as? EditContactVC{
            vc.contact = self.contact
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension ContactDetailVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
extension ContactDetailVC: UITableViewDataSource{
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
        case .birthday:
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

extension ContactDetailVC: AvatarViewDelegate{
    func didAppAvatar() {
        self.photoManager.showOptions()
    }
    
    
}
extension ContactDetailVC : PhotoManagerDelegate
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
