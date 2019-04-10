//
//  SearchingGuideOptionView.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/10/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class SearchingGuideOptionView: BaseCustomNibView {
    var type:SearchingGuideViewType = .Name{
        didSet{
            self.lbl_Title.text = type.text
            self.img_Content.image = UIImage.init(named: type.imageName)
        }
    }
    @IBOutlet weak var v_Content: UIView!
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var img_Content: UIImageView!
    override func setupViews() {
        self.lbl_Title.textColor = AppPreference.sharedInstance.appBgMode.cellTitleTextColor
        self.v_Content.backgroundColor = AppPreference.sharedInstance.appBgMode.bgColorCell
        self.v_Content.layer.cornerRadius = 8
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.img_Content.layer.cornerRadius = self.frame.size.width/2
    }
}
