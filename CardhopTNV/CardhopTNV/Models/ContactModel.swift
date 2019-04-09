//
//  ContactModel.swift
//  CardhopTNV
//
//  Created by Tu on 4/6/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import Foundation
import Contacts
class ContactModel: BaseModel{
    
    
    /*! The identifier is unique among contacts on the device. It can be saved and used for fetching contacts next application launch. */
    open var firstName: String = ""
    open var lastName: String = ""
    open var shortName: String = ""
    open var displayName: String = ""
    open var organizationName: String = ""
    open var contactType: CNContactType!
    open var thumbnailImageData: Data?
    open var phoneNumbers: [ContactLabelModel]!
    open var emailAddresses: [ContactLabelModel]!
    open var postalAddresses: [ContactAddressModel]!
    /*! The Gregorian birthday. */
    open var birthday: DateComponents?
    
    convenience init(contact: CNContact) {
        self.init()
        
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        if let displayName = formatter.string(from: contact) {
            self.displayName = displayName
            self.shortName = displayName.agc_initials(separator: " ") ?? ""
        }
        if let thumb = contact.thumbnailImageData{
            self.thumbnailImageData = thumb
        }
        self.firstName = contact.givenName
        self.lastName = contact.familyName
        self.contactType = contact.contactType
        self.phoneNumbers = self.parsePhoneLabel(phones: contact.phoneNumbers)
        self.emailAddresses = self.parseEmailLabel(emails: contact.emailAddresses)
        self.postalAddresses = self.parseAddress(addresses: contact.postalAddresses)
        self.organizationName = contact.organizationName
        self.birthday = contact.birthday
    }
    
    func parseEmailLabel(emails: [CNLabeledValue<NSString>]) -> [ContactLabelModel]{
        var contactEmail = [ContactLabelModel]()
        for email in emails{
            let tmpEmail = ContactLabelModel()
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

