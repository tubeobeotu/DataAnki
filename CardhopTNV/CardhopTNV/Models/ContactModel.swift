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
enum ContactModelSectionsType:Int{
    case mobile = 0
    case email = 1
    case address = 2
    case birthday = 3
    case note = 4
    var text: String {
        get{
            switch self {
            case .mobile:
               return "mobile"
            case .email:
                return "email"
            case .address:
                return "address"
            case .birthday:
                return "birthday"
            case .note:
                return "note"
            }
        }
    }
    var image: UIImage?{
        get{
            switch self {
            case .mobile:
                return UIImage.init(named: "mobile")
            case .email:
                return UIImage.init(named: "email")
            case .address:
                return UIImage.init(named: "address")
            case .birthday:
                return UIImage.init(named: "birthday")
            case .note:
                return UIImage.init(named: "note")
            }
        }
    }
}
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
    open var note:String = ""
    open var organizationName: String = ""
    open var contactType: Int! //0 person 1 organizarion
    open var thumbnailImageData: Data?
    let colors = [UIColor.green, UIColor.red, UIColor.yellow, UIColor.blue, UIColor.brown, UIColor.cyan, UIColor.orange]
    var stateColor:UIColor!
    
    open var phoneNumbers: [ContactLabelModel]!
    open var emailAddresses: [ContactLabelModel]!
    open var postalAddresses: [ContactAddressModel]!
    /*! The Gregorian birthday. */
    open var birthday: DateComponents?
    
    private var rawContact:CNContact!
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
        self.contactType = contact.contactType.rawValue
        self.phoneNumbers = self.parsePhoneLabel(phones: contact.phoneNumbers)
        self.emailAddresses = self.parseEmailLabel(emails: contact.emailAddresses)
        self.postalAddresses = self.parseAddress(addresses: contact.postalAddresses)
        self.organizationName = contact.organizationName
        self.birthday = contact.birthday
        self.note = contact.note
        self.displayName = calculateDisplayName()
        self.shortName = displayName.agc_initials(separator: " ") ?? ""
        self.rawContact = contact
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
    func getBirthdayString() -> String{
        if let components = birthday{
            let calendar = Calendar(identifier: .gregorian)
            let date = calendar.date(from: components)!
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy"
            let dateString = formatter.string(from: date)
            return dateString
        }
        return ""
        
    }
    func parseEmailLabel(emails: [CNLabeledValue<NSString>]) -> [ContactLabelModel]{
        var contactEmail = [ContactLabelModel]()
        for email in emails{
            let tmpEmail = ContactLabelModel()
            tmpEmail.identifier = email.identifier
            tmpEmail.isEmail = true
            tmpEmail.label = (email.label ?? "") as String
            tmpEmail.value = (email.value) as String
            contactEmail.append(tmpEmail)
        }
        return contactEmail
    }
    
    func getRawEmailLabel() -> [CNLabeledValue<NSString>]{
        var emails = [CNLabeledValue<NSString>]()
        for email in self.emailAddresses{
            let tmpAddress = CNLabeledValue(label: email.label, value: email.value as NSString)
            emails.append(tmpAddress)
        }
        return emails
    }
    
    func parsePhoneLabel(phones: [CNLabeledValue<CNPhoneNumber>]) -> [ContactLabelModel]{
        var contactPhone = [ContactLabelModel]()
        for phone in phones{
            let tmpPhone = ContactLabelModel()
            tmpPhone.identifier = phone.identifier
            tmpPhone.label = (phone.label ?? "") as String
            tmpPhone.value = (phone.value.stringValue) as String
            contactPhone.append(tmpPhone)
        }
        return contactPhone
    }
    
    func getRawPhoneLabel() -> [CNLabeledValue<CNPhoneNumber>]{
        var phones = [CNLabeledValue<CNPhoneNumber>]()
        for phone in self.phoneNumbers{
            let tmpPhone = CNLabeledValue(
                label:phone.label,
                value:CNPhoneNumber(stringValue:phone.value))
            phones.append(tmpPhone)
        }
        return phones
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
    func getRawAddressLabel() -> [CNLabeledValue<CNPostalAddress>]{
        var addresses = [CNLabeledValue<CNPostalAddress>]()
        for address in self.postalAddresses{
            let homeAddress = CNMutablePostalAddress()
            homeAddress.street = address.street
            homeAddress.subLocality = address.subLocality
            homeAddress.city = address.city
            homeAddress.subAdministrativeArea = address.subAdministrativeArea
            homeAddress.state = address.state
            homeAddress.postalCode = address.postalCode
            homeAddress.country = address.country
            homeAddress.isoCountryCode = address.countryCode
            addresses.append(CNLabeledValue(label:address.label, value:homeAddress))
        }
        return addresses
    }
    
    func sectionsAvaiable() -> [ContactModelSectionsType]{
        var sections:[ContactModelSectionsType] = [ContactModelSectionsType]()
        if(phoneNumbers.count > 0){
            sections.append(.mobile)
        }
        if(emailAddresses.count > 0){
            sections.append(.email)
        }
        if(postalAddresses.count > 0){
            sections.append(.address)
        }
        if(birthday != nil){
            sections.append(.birthday)
        }
        return sections
    }
    
    func getModelToRawContact() -> CNMutableContact{
        let contact = self.rawContact.mutableCopy() as! CNMutableContact
        contact.imageData = self.thumbnailImageData
        contact.givenName = self.firstName
        contact.familyName = self.lastName
        contact.emailAddresses = self.getRawEmailLabel()
        contact.phoneNumbers = self.getRawPhoneLabel()
        contact.postalAddresses = self.getRawAddressLabel()
        contact.birthday = self.birthday
        contact.note = self.note
        return contact
    }
    
    func getNoteModelToRawContact() -> CNMutableContact{
        let contact = self.rawContact.mutableCopy() as! CNMutableContact
        contact.note = self.note
        return contact
    }
}

