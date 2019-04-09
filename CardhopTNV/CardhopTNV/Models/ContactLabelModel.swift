//
//  ContactLabelModel.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/8/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class ContactLabelModel: BaseModel {
    open var isEmail = false
    private var _label: String = ""
    open var label: String {
        set {
            _label = newValue //Error
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
