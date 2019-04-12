//
//  ContactEditCell.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
protocol ContactEditCellDelegate {
    func didSelectDropDown(cell: ContactEditCell)
    func didSelectDelete(cell: ContactEditCell)
    func beginEditCell(cell: ContactEditCell, type: ContactModelSectionsType)
}
class ContactEditCell: BaseTableViewCell {
    var delegate:ContactEditCellDelegate?
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var btn_Icon: UIButton!
    @IBOutlet weak var btn_DropList: UIButton!
    
    @IBOutlet weak var tf_PhoneNumber: UITextField!
    var type:ContactModelSectionsType = .birthday
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btn_Icon.tintColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.tf_PhoneNumber.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.tf_PhoneNumber.delegate = self
    }
    func becomeFirstResponderCell(){
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.tf_PhoneNumber.resignFirstResponder()
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(title: String, content: String, isFirst: Bool = false){
        self.btn_DropList.setTitle(title, for: .normal)
        self.tf_PhoneNumber.text = content
        self.btn_Icon.isHidden = !isFirst
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        self.delegate?.didSelectDelete(cell: self)
    }
    @IBAction func showDropList(_ sender: Any) {
        self.delegate?.didSelectDropDown(cell: self)
    }
    
}
extension ContactEditCell: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.beginEditCell(cell: self, type: self.type)
        return self.type != .birthday
    }
}
