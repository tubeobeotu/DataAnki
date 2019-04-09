//
//  SimpleFuncTion.swift
//  CardhopTNV
//
//  Created by Tu on 4/6/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import Foundation
import Contacts
class SimpleFunction{
    class func getContacts() -> [ContactModel]{
        let contactStore = CNContactStore()
        var contacts = [ContactModel]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactBirthdayKey,
            CNContactPostalAddressesKey,
            CNContactThumbnailImageDataKey,
            CNContactOrganizationNameKey,
            CNContactTypeKey
            ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(ContactModel.init(contact: contact))
            }
        } catch {
            print("unable to fetch contacts")
        }
        
        return contacts
    }
    
    class func filterContacts(input: Array<ContactModel>, keyword: String) -> Array<ContactModel>?{
        //1 OBJECT
        let resultPredicate = NSPredicate(format: "displayName contains[cd] %@ OR organizationName", keyword)
        let searchResults = (input as NSArray).filtered(using: resultPredicate)
        return searchResults as? Array<ContactModel>
    }
    
    class func getListNumberLabels() -> [String]{
        return [CNLabelHome, CNLabelWork, CNLabelPhoneNumberiPhone, CNLabelPhoneNumberMobile, CNLabelPhoneNumberMain, CNLabelPhoneNumberHomeFax, CNLabelPhoneNumberWorkFax, CNLabelPhoneNumberOtherFax, CNLabelPhoneNumberPager, CNLabelOther]
    }
    class func getStringFromNumberLabel(label: String) -> String{
        return CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
    }
    class func getListEmailLabels() -> [String]{
        return [CNLabelHome, CNLabelWork, CNLabelEmailiCloud, CNLabelOther]
    }
    class func getStringFromEmailLabel(label: String) -> String{
        return CNLabeledValue<NSString>.localizedString(forLabel: label)
    }
}
