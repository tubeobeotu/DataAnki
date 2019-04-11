//
//  ContactEditCell.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class ContactEditCell: BaseTableViewCell {
    @IBOutlet weak var btn_Delete: UIButton!
    
    @IBOutlet weak var btn_Icon: UIButton!
    @IBOutlet weak var btn_DropList: UIButton!
    
    @IBOutlet weak var tf_PhoneNumber: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteAction(_ sender: Any) {
    }
    @IBAction func showDropList(_ sender: Any) {
    }
    
}
