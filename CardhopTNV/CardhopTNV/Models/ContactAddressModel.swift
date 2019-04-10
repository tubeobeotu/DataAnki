//
//  ContactAddressModel.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/8/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class ContactAddressModel: BaseModel {
    private var _label: String = ""
    open var label: String {
        set {
            _label = newValue //Error
        }
        get {
            return SimpleFunction.getStringFromEmailLabel(label: _label)
        }
    }
    open var street: String = ""
    open var subLocality: String = ""
    open var city: String = ""
    open var subAdministrativeArea: String = ""
    open var state: String = ""
    open var postalCode: String = ""
    open var country: String = ""
    open var countryCode: String = ""
    
    
    func checkAddress(keyword: String) -> Bool{
        if(street.lowercased().contains(keyword) || street.lowercased().contains(keyword) || subLocality.lowercased().contains(keyword) || city.lowercased().contains(keyword) || subAdministrativeArea.lowercased().contains(keyword) || postalCode.lowercased().contains(keyword) || country.lowercased().contains(keyword) ||
            country.lowercased().contains(keyword)){
            return true
        }
        return false
    }
}
