//
//  SettingNormalCell.swift
//  CardhopTNV
//
//  Created by Tu on 4/10/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class SettingNormalCell: BaseTableViewCell {

    @IBOutlet weak var lbl_Title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lbl_Title.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
