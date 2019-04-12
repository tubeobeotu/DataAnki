//
//  AvatarView.swift
//  CardhopTNV
//
//  Created by Tu on 4/5/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
protocol AvatarViewDelegate{
    func didAppAvatar()
}
class AvatarView: BaseCustomNibView {
    @IBOutlet weak var img_Profile: UIImageView!
    @IBOutlet weak var v_Name: UIView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var v_ContainerLblName: UIView!
    var delegate:AvatarViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.lbl_Name.backgroundColor = UIColor.init(rgb: 0xA3A7B3)
        self.setTextColor(color: UIColor.white)
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width/2
//        self.v_Name.layer.cornerRadius = self.v_Name.frame.size.width/2
//        self.lbl_Name.layer.cornerRadius = self.lbl_Name.frame.size.width/2
        self.v_ContainerLblName.layer.cornerRadius = self.frame.size.width/2
    }
    
    func setStateColor(color: UIColor){
        self.v_Name.backgroundColor = color
    }
    func setTextColor(color: UIColor){
        self.lbl_Name.textColor = color
    }
    func setImage(image: UIImage?){
        self.img_Profile.image = image
    }
    
    @IBAction func didTapAvatar(_ sender: Any) {
        self.delegate?.didAppAvatar()
    }
    
}
