//
//  ContactDetailCell.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
protocol ContactDetailCellDelegate {
    func beginEdit(type: ContactModelSectionsType, tf: UITextField)
}
class ContactDetailCell: BaseTableViewCell {
    var type:ContactModelSectionsType = .mobile
    var isEdit = false{
        didSet{
            self.tf_Content.isEnabled = isEdit
        }
    }
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var tf_Content: UITextField!
    @IBOutlet weak var btn_Icon: UIButton!
    var delegate:ContactDetailCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isEdit = false
        self.tf_Content.delegate = self
        self.btn_Icon.tintColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.lbl_Title.textColor = AppPreference.sharedInstance.settings.appBgMode.cellContentTextColor
        self.tf_Content.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(title: String, content: String, isFirst: Bool = false){
        self.lbl_Title.text = title
        self.tf_Content.text = content
        self.btn_Icon.isHidden = !isFirst
    }
    
}

extension ContactDetailCell: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.beginEdit(type: self.type, tf: self.tf_Content)
        return true
    }
}
