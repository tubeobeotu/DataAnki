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
    open var identifier: String = ""
    
    
    open var contactType: CNContactType!
    
    
    open var namePrefix: String! = ""
    
    open var givenName: String! = ""
    
    open var middleName: String! = ""
    
    open var familyName: String! = ""
    
    open var previousFamilyName: String! = ""
    
    open var nameSuffix: String! = ""
    
    open var nickname: String! = ""
    
    
    open var organizationName: String! = ""
    
    open var departmentName: String! = ""
    
    open var jobTitle: String! = ""
    
    
    open var phoneticGivenName: String! = ""
    
    open var phoneticMiddleName: String! = ""
    
    open var phoneticFamilyName: String! = ""
    
    open var note: String! = ""
    
    
    open var imageData: Data?
    
    open var thumbnailImageData: Data?
    
    open var phoneNumbers: [CNLabeledValue<CNPhoneNumber>]!
    
    open var emailAddresses: [CNLabeledValue<NSString>]!
    
    open var postalAddresses: [CNLabeledValue<CNPostalAddress>]!
    
    open var urlAddresses: [CNLabeledValue<NSString>]!
    
    open var contactRelations: [CNLabeledValue<CNContactRelation>]!
    
    open var socialProfiles: [CNLabeledValue<CNSocialProfile>]!
    
    open var instantMessageAddresses: [CNLabeledValue<CNInstantMessageAddress>]!
    
    
    /*! The Gregorian birthday. */
    open var birthday: DateComponents?!
    
    
    /*! The alternate birthday (Lunisolar). */
    open var nonGregorianBirthday: DateComponents?
    
    
    /*! Other Gregorian dates (anniversaries, etc). */
    open var dates: [CNLabeledValue<NSDateComponents>]!

    
    
    func getFirstLetterName() -> String{
        return nameSuffix
    }
}

