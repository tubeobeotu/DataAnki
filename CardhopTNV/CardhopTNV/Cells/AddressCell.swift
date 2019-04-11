//
//  AddressCell.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class AddressCell: BaseTableViewCell {
    @IBOutlet weak var btn_Icon: UIButton!
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var lbl_Content: UILabel!
    
    @IBOutlet weak var v_Map: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btn_Icon.tintColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.lbl_Title.textColor = AppPreference.sharedInstance.settings.appBgMode.cellContentTextColor
        self.lbl_Content.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.v_Map.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(address: ContactAddressModel){
        self.lbl_Title.text = address.label
        self.lbl_Content.text = address.getAddressString(iso: AppPreference.sharedInstance.settings.addressFormat)
        
    }
}
