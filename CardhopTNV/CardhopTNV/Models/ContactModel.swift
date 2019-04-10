//
//  ContactModel.swift
//  CardhopTNV
//
//  Created by Tu on 4/6/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import Foundation
import Contacts
import UIKit
class ContactModel: BaseModel{
    
    private var _displayShortField: String = ""
    private var _displayName: String = ""
    private var _shortName: String = ""
    open var displayShortField: String {
        set {
            _displayShortField = newValue //Error
        }
        get {
            switch AppPreference.sharedInstance.settings.sortType {
            case .FirstNameLastName:
                return "\(self.firstName)\(self.lastName)"
            case .LastNameFirstName:
                return "\(self.lastName)\(self.firstName)"
            }
        }
    }

    open var firstName: String = ""
    open var lastName: String = ""
    open var shortName: String{
        set {
            _shortName = newValue
        }
        get {
            return displayName.agc_initials(separator: " ") ?? ""
        }
    }
    open var displayName: String {
        set{
            _displayName = newValue
        }
        get{
            return self.calculateDisplayName()
        }
    }
    open var organizationName: String = ""
    open var contactType: CNContactType!
    open var thumbnailImageData: Data?
    let colors = [UIColor.green, UIColor.red, UIColor.yellow, UIColor.blue, UIColor.brown, UIColor.cyan, UIColor.orange]
    var stateColor:UIColor!
    
    open var phoneNumbers: [ContactLabelModel]!
    open var emailAddresses: [ContactLabelModel]!
    open var postalAddresses: [ContactAddressModel]!
    /*! The Gregorian birthday. */
    open var birthday: DateComponents?
    
    convenience init(contact: CNContact) {
        self.init()
        
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        //        if let displayName = formatter.string(from: contact) {
        //            self.displayName = displayName
        //            self.shortName = displayName.agc_initials(separator: " ") ?? ""
        //        }
        
        if let thumb = contact.thumbnailImageData{
            self.thumbnailImageData = thumb
        }
        let randomInt = Int(arc4random_uniform(UInt32(colors.count)))
        self.stateColor = colors[randomInt]
        self.identifier = contact.identifier
        self.firstName = contact.givenName
        self.lastName = contact.familyName
        self.contactType = contact.contactType
        self.phoneNumbers = self.parsePhoneLabel(phones: contact.phoneNumbers)
        self.emailAddresses = self.parseEmailLabel(emails: contact.emailAddresses)
        self.postalAddresses = self.parseAddress(addresses: contact.postalAddresses)
        self.organizationName = contact.organizationName
        self.birthday = contact.birthday
        
        self.displayName = calculateDisplayName()
        self.shortName = displayName.agc_initials(separator: " ") ?? ""
    }
    func calculateDisplayName() -> String{
        switch AppPreference.sharedInstance.settings.displayName {
        case .FistLast:
            return "\(firstName) \(lastName)"
        case .LastFirst:
            return "\(lastName) \(firstName)"
        case .LastFirst2:
            return "\(lastName), \(firstName)"
        }
    }
    func parseEmailLabel(emails: [CNLabeledValue<NSString>]) -> [ContactLabelModel]{
        var contactEmail = [ContactLabelModel]()
        for email in emails{
            let tmpEmail = ContactLabelModel()
            tmpEmail.identifier = email.identifier
            tmpEmail.isEmail = true
            tmpEmail.identifier = email.identifier
            tmpEmail.label = (email.label ?? "") as String
            tmpEmail.value = (email.value) as String
            contactEmail.append(tmpEmail)
        }
        return contactEmail
    }
    
    func parsePhoneLabel(phones: [CNLabeledValue<CNPhoneNumber>]) -> [ContactLabelModel]{
        var contactPhone = [ContactLabelModel]()
        for phone in phones{
            let tmpPhone = ContactLabelModel()
            tmpPhone.identifier = phone.identifier
            tmpPhone.identifier = phone.identifier
            tmpPhone.label = (phone.label ?? "") as String
            tmpPhone.value = (phone.value.stringValue) as String
            contactPhone.append(tmpPhone)
        }
        return contactPhone
    }
    
    func parseAddress(addresses: [CNLabeledValue<CNPostalAddress>]) -> [ContactAddressModel]{
        var contactAddresses = [ContactAddressModel]()
        for address in addresses{
            let tmpAddress = ContactAddressModel()
            tmpAddress.identifier = address.identifier
            let cnPostAddress = address.value
            tmpAddress.label = (address.label ?? "") as String
            tmpAddress.street = cnPostAddress.street
            tmpAddress.subLocality = cnPostAddress.subLocality
            tmpAddress.city = cnPostAddress.city
            tmpAddress.subAdministrativeArea = cnPostAddress.subAdministrativeArea
            tmpAddress.state = cnPostAddress.state
            tmpAddress.postalCode = cnPostAddress.postalCode
            tmpAddress.country = cnPostAddress.country
            tmpAddress.countryCode = cnPostAddress.isoCountryCode
            contactAddresses.append(tmpAddress)
        }
        
        
        return contactAddresses
    }
}

