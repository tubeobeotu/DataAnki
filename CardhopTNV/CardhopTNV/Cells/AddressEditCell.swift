//
//  AddressEditCell.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/12/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
enum AddressType:Int{
    case street = 1000
    case province = 1001
    case city = 1002
    case postCode = 1003
    case country = 1004
}
protocol AddressEditCellDelegate{
    func changeAddressValue(cell: AddressEditCell, type: AddressType, value: String)
    func didSelectAddressDropDown(cell: AddressEditCell)
    func didSelectRemoveDropDown(cell: AddressEditCell)
}
class AddressEditCell: BaseTableViewCell {
    var delegate: AddressEditCellDelegate?
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
        self.btn_Delete.layer.cornerRadius = self.btn_Delete.frame.width/2
        self.btn_Icon.setImage(ContactModelSectionsType.address.image, for: .normal)
        self.btn_Icon.tintColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        
        self.tf_Province.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.tf_City.textColor = self.tf_Province.textColor
        self.tf_PostCode.textColor = self.tf_Province.textColor
        self.tf_Country.textColor = self.tf_Province.textColor
        
        self.tf_Province.tag = AddressType.province.rawValue
        self.tf_City.tag = AddressType.city.rawValue
        self.tf_PostCode.tag = AddressType.postCode.rawValue
        self.tf_Country.tag = AddressType.country.rawValue
        
        self.tf_City.delegate = self
        self.tf_Street.delegate = self
        self.tf_Country.delegate = self
        self.tf_PostCode.delegate = self
        self.tf_Province.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupModel(address: ContactAddressModel){
        self.btn_DropDown.setTitle(address.label, for: .normal)
        self.tf_Street.text = address.street
        self.tf_Province.text = address.state
        self.tf_City.text = address.city
        self.tf_Country.text = address.country
        self.tf_PostCode.text = address.postalCode
    }
    
    @IBAction func actionDelegate(_ sender: UIButton) {
        self.delegate?.didSelectAddressDropDown(cell: self)
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        self.delegate?.didSelectRemoveDropDown(cell: self)
    }
    
}
extension AddressEditCell: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            self.delegate?.changeAddressValue(cell: self, type: AddressType(rawValue: textField.tag) ?? .street, value: updatedText)
        }else{
            self.delegate?.changeAddressValue(cell: self, type: AddressType(rawValue: textField.tag) ?? .street, value: "")
        }
        return true
    }
}
