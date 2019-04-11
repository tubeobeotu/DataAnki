//
//  ContactDetailCell.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class ContactDetailCell: BaseTableViewCell {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Content: UILabel!
    @IBOutlet weak var btn_Icon: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btn_Icon.tintColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.lbl_Title.textColor = AppPreference.sharedInstance.settings.appBgMode.cellContentTextColor
        self.lbl_Content.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(title: String, content: String, isFirst: Bool = false){
        self.lbl_Title.text = title
        self.lbl_Content.text = content
        self.btn_Icon.isHidden = !isFirst
    }
    
}
