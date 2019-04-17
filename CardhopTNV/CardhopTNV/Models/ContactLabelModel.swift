//
//  ContactLabelModel.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/8/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
import Contacts
class ContactLabelModel: BaseModel {
    open var isNew = false
    open var isEmail = false
    private var _label: String = ""
    open var label: String {
        set {
            if(newValue == ""){
                _label = CNLabelHome
            }else{
                _label = newValue //Error
            }
            
        }
        get {
            if(self.isEmail == false){
                return SimpleFunction.getStringFromNumberLabel(label: _label)
            }else{
                return SimpleFunction.getStringFromEmailLabel(label: _label)
            }
        }
    }
    open var value: String = ""

}
