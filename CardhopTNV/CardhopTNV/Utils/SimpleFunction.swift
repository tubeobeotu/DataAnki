//
//  SimpleFuncTion.swift
//  CardhopTNV
//
//  Created by Tu on 4/6/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import Foundation
import Contacts
import UIKit
import MessageUI
class SimpleFunction{
    class func getContacts(){
        self.requestAccess { (accessGranted) in
            if(accessGranted == true){
                var contacts = [ContactModel]()
                let keys = [
                    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactPhoneNumbersKey,
                    CNContactEmailAddressesKey,
                    CNContactBirthdayKey,
                    CNContactPostalAddressesKey,
                    CNContactThumbnailImageDataKey,
                    CNContactOrganizationNameKey,
                    CNContactTypeKey,
                    CNContactNoteKey,
                    CNContactImageDataKey
                    ] as [Any]
                let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
                do {
                    try AppPreference.sharedInstance.contactStore.enumerateContacts(with: request){
                        (contact, stop) in
                        // Array containing all unified contacts from everywhere
                        contacts.append(ContactModel.init(contact: contact))
                    }
                } catch {
                    print("unable to fetch contacts")
                }
                self.calculateContactsFromLocal(contacts: contacts)
                
            }
        }
        
    }
    
    class func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            AppPreference.sharedInstance.contactStore.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        }
    }
    
    class private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
            completionHandler(false)
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        if let topController = self.getTopVC(){
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func getTopVC() -> BaseViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if let tabbar = topController as? UITabBarController{
                if let nav = tabbar.selectedViewController as? UINavigationController{
                    return nav.viewControllers.first as? BaseViewController
                }
                return tabbar.selectedViewController as? BaseViewController
            }
            return topController as? BaseViewController
            // topController should now be your topmost view controller
        }
        return nil
    }
    class func filterContacts(input: Array<ContactModel>, keyword: String) -> Array<ContactModel>?{
        //1 OBJECT
//        let resultPredicate = NSPredicate(format: "firstName = 'Robert'")
//        let searchResults = (input as NSArray).filtered(using: resultPredicate)
        return input.filter { $0.displayName.lowercased().contains(keyword.lowercased())}
//         || $0.organizationName.lowercased().contains(keyword.lowercased())
    }

    class func filterContactsHighLevel(input: Array<ContactModel>, keyword: String) -> Array<ContactModel>?{
        return input.filter { $0.displayName.lowercased().contains(keyword.lowercased()) || self.checkContact(data: $0.phoneNumbers, keyword: keyword) || self.checkContact(data: $0.emailAddresses, keyword: keyword) ||
            self.checkContact(data: $0.postalAddresses, keyword: keyword)
        }
    }
    class func checkContact(data: [ContactLabelModel], keyword: String) -> Bool{
        for tmpData in data{
            if(tmpData.value.lowercased().contains(keyword.lowercased())){
                return true
            }
        }
        return false
    }
    class func checkContact(data: [ContactAddressModel], keyword: String) -> Bool{
        for tmpData in data{
            if(tmpData.checkAddress(keyword: keyword.lowercased())){
                return true
            }
        }
        return false
    }
    
    
    class func filterContacts(input: Array<ContactModel>, beginWith keyword: String) -> Array<ContactModel>?{
        return input.filter { $0.displayName.lowercased().hasPrefix(keyword.lowercased()) }
    }
    
    
    class func checkContainContacts(input: Array<ContactModel>, beginWith keyword: String) -> Bool{
        for contact in input{
            if(contact.displayName.lowercased().hasPrefix(keyword.lowercased())){
                return true
            }
        }
        return false
    }
    
    class func checkContactInList(contact: ContactModel, contacts:[ContactModel]) -> Bool{
        for tmpContact in contacts{
            if(tmpContact.identifier == contact.identifier){
                return true
            }
        }
        return false
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
    
    class func insertContactToFavourit(contact: ContactModel){
        AppPreference.sharedInstance.favouritContacts.insert(contact, at: 0)
    }
    class func insertContactToRecent(contact: ContactModel){
        if(!self.checkContactInList(contact: contact, contacts: AppPreference.sharedInstance.recentContacts)){
            AppPreference.sharedInstance.recentContacts.insert(contact, at: 0)
        }
    }
    class func insertContactToBirthDay(contact: ContactModel){
        if(!self.checkContactInList(contact: contact, contacts: AppPreference.sharedInstance.birthdayContacts)){
            AppPreference.sharedInstance.birthdayContacts.insert(contact, at: 0)
        }
    }
    class func insertContactToContacts(contact: ContactModel){
        if(!self.checkContactInList(contact: contact, contacts: AppPreference.sharedInstance.contacts)){
            AppPreference.sharedInstance.contacts.insert(contact, at: 0)
        }
        self.insertContactToRecent(contact: contact)
    }
    class func deleteOptionContact(contact: ContactModel, from contacts: [ContactModel]) -> [ContactModel]{
        var tmpContacts = contacts
        let index = getContact(contacts: tmpContacts, id: contact.identifier)
        if(index != -1){
            tmpContacts.remove(at: index)
        }
        return tmpContacts
    }
    class func deleteContactToFavourit(contact: ContactModel){
       AppPreference.sharedInstance.favouritContacts = self.deleteOptionContact(contact: contact, from: AppPreference.sharedInstance.favouritContacts)
    }
    class func deleteContactToRecent(contact: ContactModel){
        AppPreference.sharedInstance.recentContacts = self.deleteOptionContact(contact: contact, from: AppPreference.sharedInstance.recentContacts)
    }
    class func deleteContactToBirthDay(contact: ContactModel){
        AppPreference.sharedInstance.birthdayContacts = self.deleteOptionContact(contact: contact, from: AppPreference.sharedInstance.birthdayContacts)
    }
    class func deleteContactToContacts(contact: ContactModel){
        AppPreference.sharedInstance.contacts = self.deleteOptionContact(contact: contact, from: AppPreference.sharedInstance.contacts)
        self.calculateContactsFromLocal(contacts: AppPreference.sharedInstance.contacts)
    }
    
    
    class func calculateContactsFromLocal(contacts: [ContactModel]){
        var sortedContacts:[ContactModel]!
//        if(isFirst){
            sortedContacts = contacts.sorted(by: { $0.displayShortField < $1.displayShortField})
//        }else{
//            sortedContacts = sortedContacts.reversed()
//        }
        
        let fafouritIdentifiers = ContactFileManager.getPlist(withName: ContactFileManager.FAVOURITCONTACTSFILENAME)
        let recentIdentifiers = ContactFileManager.getPlist(withName: ContactFileManager.RECENTCONTACTSFILENAME)
        if let fafouritIdentifiers = fafouritIdentifiers{
            self.calculateFavouritContacts(contacts: sortedContacts, favouritIds: fafouritIdentifiers)
        }
        if let recentIdentifiers = recentIdentifiers{
            self.calculateRecentContacts(contacts: sortedContacts, recentIds: recentIdentifiers)
        }
        self.calculateBirthdayContacts(contacts: sortedContacts)
        
        AppPreference.sharedInstance.contacts = sortedContacts
        
    }
    class func getSettingsFromLocal(){
        if let settingsDict = ContactFileManager.getSettingPlist(withName: ContactFileManager.SETTINGSFILENAME){
            AppPreference.sharedInstance.settings = GeneralSettingModel.init(dictionary: settingsDict)
        }
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
    class func getContact(contacts: [ContactModel], id: String) -> Int{
        for (index, contact) in contacts.enumerated(){
            if(id == contact.identifier){
                return index
            }
        }
        return -1
    }
    class func saveContact(contact: ContactModel){
        self.insertContactToRecent(contact: contact)
        let model = contact.getModelToRawContact()
        // Saving the newly created contact
        let store = AppPreference.sharedInstance.contactStore
        let saveRequest = CNSaveRequest()
        saveRequest.update(model)
        do {
            try store.execute(saveRequest)
        } catch {
            print("unable to update contacts")
        }
    }
    class func saveContactNote(contact: ContactModel){
        self.insertContactToRecent(contact: contact)
        let model = contact.getNoteModelToRawContact()
        let store = AppPreference.sharedInstance.contactStore
        let saveRequest = CNSaveRequest()
        saveRequest.update(model)
        do {
            try store.execute(saveRequest)
        } catch {
            print("unable to update contacts")
        }
    }
    
    class func deleteContactFromSystem(contact: ContactModel){
        let model = contact.getModelToRawContact()
        let store = AppPreference.sharedInstance.contactStore
        let saveRequest = CNSaveRequest()
        saveRequest.delete(model)
        do {
            try store.execute(saveRequest)
        } catch {
            print("unable to update contacts")
        }
    }
    
    
    //Call
    class func callNumber(phoneNumber:String, vc: UIViewController) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }else{
                vc.showAlert(content: "Can not call to the phone number")
            }
        }
    }
    class func sendMessage(phoneNumber:String, content: String, vc: UIViewController) {
        let composeVC = MFMessageComposeViewController()
//        composeVC.messageComposeDelegate = vc as! MFMessageComposeViewControllerDelegate
        // Configure the fields of the interface.
        composeVC.recipients = [phoneNumber]
        composeVC.body = content
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            vc.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    class func sendEmail(email:String, content: String, vc: UIViewController) {
        if(MFMailComposeViewController.canSendMail()){
            let composeVC = MFMailComposeViewController()
            //        composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients([email])
            composeVC.setSubject("")
            composeVC.setMessageBody(content, isHTML: false)
            
            // Present the view controller modally.
            vc.present(composeVC, animated: true, completion: nil)
        }else{
            vc.showAlert(content: "Please set up your email!")
        }
    }
    class func facetime(phoneNumber:String, vc: UIViewController) {
        if let phoneCallURL = URL(string: "facetime://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
            else{
                vc.showAlert(content: "Can not video call to the phone number")
            }
        }
    }

}
