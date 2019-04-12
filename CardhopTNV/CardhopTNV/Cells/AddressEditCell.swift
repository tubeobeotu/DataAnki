//
//  AddressEditCell.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/12/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class AddressEditCell: BaseTableViewCell {
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var btn_DropDown: UIButton!
    @IBOutlet weak var btn_Icon: UIButton!
    @IBOutlet weak var tf_Street: UITextField!
    @IBOutlet weak var tf_Province: UITextField!
    @IBOutlet weak var tf_City: UITextField!
    @IBOutlet weak var tf_PostCode: UITextField!
    @IBOutlet weak var tf_Country: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btn_Icon.tintColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.tf_Province.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.tf_City.textColor = self.tf_Province.textColor
        self.tf_PostCode.textColor = self.tf_Province.textColor
        self.tf_Country.textColor = self.tf_Province.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupModel(address: ContactAddressModel){
        
    }
    
}
