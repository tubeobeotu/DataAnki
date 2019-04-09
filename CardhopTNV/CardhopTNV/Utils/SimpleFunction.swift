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
    class func getContacts(){
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
        self.calculateContactsFromLocal(contacts: contacts)
        AppPreference.sharedInstance.contacts = contacts
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
    
    class func calculateContactsFromLocal(contacts: [ContactModel]){
        let fafouritIdentifiers = ContactFileManager.getPlist(withName: ContactFileManager.FAVOURITCONTACTSFILENAME)
        let recentIdentifiers = ContactFileManager.getPlist(withName: ContactFileManager.RECENTCONTACTSFILENAME)
        if let fafouritIdentifiers = fafouritIdentifiers{
            self.calculateFavouritContacts(contacts: contacts, favouritIds: fafouritIdentifiers)
        }
        if let recentIdentifiers = recentIdentifiers{
            self.calculateRecentContacts(contacts: contacts, recentIds: recentIdentifiers)
        }
        self.calculateBirthdayContacts(contacts: contacts)
        
    }
    
    class func calculateRecentContacts(contacts: [ContactModel], recentIds: [String]){
        AppPreference.sharedInstance.recentContacts = self.getContacts(contacts: contacts, ids: recentIds)
    }
    class func calculateFavouritContacts(contacts: [ContactModel], favouritIds: [String]){
         AppPreference.sharedInstance.favouritContacts = self.getContacts(contacts: contacts, ids: favouritIds)
    }
    class func calculateBirthdayContacts(contacts: [ContactModel]){
        var validedContacts = [ContactModel]()
        let date = Date()
        let currentDateComs = Calendar.current.dateComponents([.year, .month, .day], from: date)
        for contact in contacts{
            if(contact.birthday?.month == currentDateComs.month && contact.birthday?.day == currentDateComs.day){
                validedContacts.append(contact)
            }
        }
        AppPreference.sharedInstance.birthdayContacts = validedContacts
    }
    class func getContacts(contacts: [ContactModel], ids: [String]) -> [ContactModel]{
        var validedContacts = [ContactModel]()
        for contact in contacts{
            if(ids.contains(contact.identifier)){
                validedContacts.append(contact)
            }
        }
        return validedContacts
    }
}
