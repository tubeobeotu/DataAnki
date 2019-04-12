//
//  DateExtension.swift
//  CardhopTNV
//
//  Created by Tu on 4/9/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import Foundation
extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    var dateComponents: DateComponents{
        let units: Set<Calendar.Component> = [.day, .month, .year]
        let comps = Calendar.current.dateComponents(units, from: self)
        return comps
    }
}
