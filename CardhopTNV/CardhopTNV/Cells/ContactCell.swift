//
//  ContactCell.swift
//  CardhopTNV
//
//  Created by Tu on 4/3/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class ContactCell: BaseTableViewCell {

    @IBOutlet weak var v_Avatar: AvatarView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_SubName: UILabel!
    @IBOutlet weak var v_Content: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.v_Content.layer.cornerRadius = 8
        self.v_Content.backgroundColor = AppPreference.sharedInstance.appBgMode.bgColorCell
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModelForCell(contact: ContactModel, isHideSubLabel: Bool = false){
        self.lbl_Name.textColor = AppPreference.sharedInstance.appBgMode.cellTitleTextColor
        self.lbl_SubName.textColor = AppPreference.sharedInstance.appBgMode.cellContentTextColor
        self.lbl_Name.text = contact.displayName
        if(isHideSubLabel == false){
            self.lbl_SubName.text = contact.organizationName
        }else{
            self.lbl_SubName.text = ""
        }
        self.v_Avatar.lbl_Name.text = contact.shortName
    }
    
}
