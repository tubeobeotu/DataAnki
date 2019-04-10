//
//  ContactCell.swift
//  CardhopTNV
//
//  Created by Tu on 4/3/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class ContactCell: BaseTableViewCell {

    @IBOutlet weak var btn_Image: UIButton!
    @IBOutlet weak var v_Avatar: AvatarView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_SubName: UILabel!
    @IBOutlet weak var v_Content: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.v_Content.layer.cornerRadius = 8
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModelForCell(contact: ContactModel, isHideSubLabel: Bool = false, canSelect: Bool = true){
        self.btn_Image.tintColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.v_Content.backgroundColor =  AppPreference.sharedInstance.settings.appBgMode.bgColorCell
        self.v_Avatar.setStateColor(color: contact.stateColor)
        self.lbl_Name.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.lbl_SubName.textColor = AppPreference.sharedInstance.settings.appBgMode.cellContentTextColor
        self.lbl_Name.text = contact.displayName
        if(isHideSubLabel == false){
            self.lbl_SubName.text = contact.organizationName
        }else{
            self.lbl_SubName.text = ""
        }
        
        if(canSelect == true){
            self.lbl_Name.alpha = 1.0
            self.lbl_SubName.alpha = 1.0
        }else{
            self.lbl_Name.alpha = 0.5
            self.lbl_SubName.alpha = 0.5
        }
        self.v_Avatar.lbl_Name.text = contact.shortName
    }
    
}
