//
//  ContactActionDetailView.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
enum ActionType: Int{
    case Message = 0
    case Email = 1
    case Call = 2
    case Video = 3
    
    var text: String{
        get{
            switch(self){
            case .Message: return "message"
            case .Email: return "email"
            case .Call: return "call"
            case .Video: return "video"
            }
        }
    }
    var image: UIImage?{
        switch(self){
        case .Message: return UIImage.init(named: "ic_message")
        case .Email: return  UIImage.init(named: "ic_email")
        case .Call: return  UIImage.init(named: "ic_call")
        case .Video: return  UIImage.init(named: "ic_video")
        }
    }
    var textColor:UIColor{
        if(self == .Message || self == .Email){
            return AppPreference.sharedInstance.settings.appBgMode.selectedThemeBg
        }
        return UIColor.green
    }
}
protocol ContactActionDetailViewDelegate {
    func didSelectAction(type: ActionType)
}
class ContactActionDetailView: BaseCustomNibView {
    var type:ActionType = .Message{
        didSet{
            self.lbl_Content.text = type.text
            self.lbl_Content.textColor = type.textColor
            self.btn_Icon.setImage(type.image, for: .normal)
            self.btn_Icon.tintColor = UIColor.white
            self.btn_Icon.backgroundColor = self.type.textColor
        }
    }
    var delegate:ContactActionDetailViewDelegate?
    
    @IBOutlet weak var btn_Icon: UIButton!
    @IBOutlet weak var lbl_Content: UILabel!
    
    override func setupViews() {
    
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.btn_Icon.layer.cornerRadius = self.btn_Icon.frame.size.width/2
    }
    
    @IBAction func action(_ sender: Any) {
        self.delegate?.didSelectAction(type: type)
    }
    
}
