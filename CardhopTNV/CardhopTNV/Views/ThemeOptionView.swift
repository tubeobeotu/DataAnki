//
//  ThemeOptionView.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/9/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class ThemeOptionView: BaseCustomNibView {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var v_Bg: UIView!
    @IBOutlet weak var img_Contant: UIImageView!
    var mode:AppBgMode = .Default{
        didSet{
            self.lbl_Title.text = self.mode.text
        }
    }
    var isSelected = false{
        didSet{
            if(isSelected == true){
                self.lbl_Title.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
                self.lbl_Title.font = UIFont.systemFont(ofSize: 14)
                self.v_Bg.backgroundColor = AppPreference.sharedInstance.settings.appBgMode.selectedThemeBg
            }else{
                self.lbl_Title.textColor = AppPreference.sharedInstance.settings.appBgMode.cellContentTextColor
                self.lbl_Title.font = UIFont.boldSystemFont(ofSize: 14)
                self.v_Bg.backgroundColor = AppPreference.sharedInstance.settings.appBgMode.unSelectedThemeBg
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        self.v_Bg.layer.cornerRadius = 8
    }
    @IBAction func action(_ sender: Any) {
        self.isSelected = !isSelected
        if(isSelected){
            AppPreference.sharedInstance.settings.appBgMode = self.mode
        }
        
    }
    
}
