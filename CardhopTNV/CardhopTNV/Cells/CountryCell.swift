//
//  CountryCell.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/10/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class CountryCell: BaseTableViewCell {
    var type:OptionIndexType = .AddressFormat{
        didSet{
            if(type != .DefaultCountryCode){
                self.lbl_Seperator.text = ""
                self.lbl_Code.text = ""
            }
        }
    }
    @IBOutlet weak var lbl_Code: UILabel!
    @IBOutlet weak var lbl_Seperator: UILabel!
    
    @IBOutlet weak var img_View: UIImageView!
    @IBOutlet weak var lbl_CountryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func refreshUI(){
        self.lbl_Code.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.lbl_Seperator.textColor = self.lbl_Code.textColor
        self.lbl_CountryName.textColor = self.lbl_Code.textColor
    }
    func setupCountry(country: CountryModel){
        self.refreshUI()
        if(self.type == .DefaultCountryCode){
            self.lbl_Code.text = country.phoneCode
        }
        self.img_View.image = country.flag
        self.lbl_CountryName.text = country.name
    }
    
}
