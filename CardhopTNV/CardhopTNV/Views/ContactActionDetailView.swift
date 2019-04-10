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
    var image: UIImage{
        switch(self){
        case .Message: return UIImage.init(named: "message")!
        case .Email: return  UIImage.init(named: "email")!
        case .Call: return  UIImage.init(named: "call")!
        case .Video: return  UIImage.init(named: "video")!
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
            self.img_View.image = type.image
        }
    }
    var delegate:ContactActionDetailViewDelegate?
    @IBOutlet weak var img_View: UIImageView!
    @IBOutlet weak var lbl_Content: UILabel!
    
    override func setupViews() {
        
    }
    
    @IBAction func action(_ sender: Any) {
        self.delegate?.didSelectAction(type: type)
    }
    
}
