//
//  CountryModel.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/10/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class CountryModel: BaseModel {
    public var name: String
    public var code: String
    public var phoneCode: String
    public var flag: UIImage {
        return UIImage(named: "CountryPickerView.bundle/Images/\(code.uppercased())",
            in: Bundle(for: ContactCountryVC.self), compatibleWith: nil)!
    }
    
    internal init(name: String, code: String, phoneCode: String) {
        self.name = name
        self.code = code
        self.phoneCode = phoneCode
    }
}
