//
//  ContactNoteCell.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class ContactNoteCell: BaseTableViewCell {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var tv_Content: UITextView!
    
    @IBOutlet weak var btn_Icon: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btn_Icon.tintColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.lbl_Title.textColor = AppPreference.sharedInstance.settings.appBgMode.cellContentTextColor
        self.tv_Content.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
