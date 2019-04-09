//
//  StringExtension.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/8/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import Foundation
extension String{
    
    func agc_isStringComposedOnly(bySpacesOrNewLines string: String?) -> Bool {
        let whiteSpaceAndNewLinesSet = CharacterSet.whitespacesAndNewlines
        if (string?.trimmingCharacters(in: whiteSpaceAndNewLinesSet).count ?? 0) == 0 {
            return true
        }
        return false
    }
    
    func agc_initials(separator: String?) -> String? {
        let nameComponents = self.components(separatedBy: separator ?? "")
        var nameComponentsCleaned = Array<Any>()
        for nameComponent in nameComponents {
            let nameComponentIsNotValid: Bool = (nameComponent == "" || nameComponent.count == 0 || (nameComponent == separator) || agc_isStringComposedOnly(bySpacesOrNewLines: self))
            if nameComponentIsNotValid {
                continue
            }
            nameComponentsCleaned.append(nameComponent)
        }
        
        let nameComponentsCleanedIsEmpty: Bool = nameComponentsCleaned.count < 1
        if nameComponentsCleanedIsEmpty {
            return ""
        }
        let firstComponent = nameComponentsCleaned[0] as? String
        let firstInitial = (firstComponent as NSString?)?.substring(to: 1)
        var lastComponent = ""
        var lastInitial = ""
        if nameComponentsCleaned.count > 1 {
            lastComponent = nameComponentsCleaned.last as? String ?? ""
            lastInitial = (lastComponent as NSString).substring(to: 1)
        }
        return (firstInitial ?? "") + lastInitial
    }
    func isValidedString() -> Bool
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
}
