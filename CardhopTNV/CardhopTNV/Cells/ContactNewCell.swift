//
//  ContactNewCell.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
enum ContactNewCellType:Int{
    case phone = 0
    case email = 1
    case address = 2
    var title: String{
        switch self {
        case .email:
            return "Add Email"
        case .phone:
            return "Add Phone Number"
        case .address:
            return "Add Address"
        }
    }
}
protocol ContactNewCellDelegate{
    func didTapAddNew(type: ContactNewCellType)
}
class ContactNewCell: BaseTableViewCell {
    var type:ContactNewCellType = .email{
        didSet{
            self.lbl_Title.text = type.title
        }
    }
    var delegate:ContactNewCellDelegate?
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_Icon: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lbl_Title.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.btn_Icon.layer.cornerRadius = 15
        self.btn_Icon.clipsToBounds = true
        
    }

    @IBAction func tapAddNew(_ sender: Any) {
        self.delegate?.didTapAddNew(type: self.type)
    }

    
}
