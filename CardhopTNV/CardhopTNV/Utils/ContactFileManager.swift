//
//  ContactFileManager.swift
//  CardhopTNV
//
//  Created by Tu on 4/9/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import Foundation

class ContactFileManager: NSObject{
    static let FAVOURITCONTACTSFILENAME = "FAVOURITCONTACTSFILENAME"
    static let RECENTCONTACTSFILENAME = "RECENTCONTACTSFILENAME"
    static let SETTINGSFILENAME = "SETTINGSFILENAME"
    class func applicationDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let basePath = paths.first ?? ""
        return basePath
    }
    class func getPlist(withName name: String) -> [String]?
    {
        let path = applicationDocumentsDirectory() + "/\(name).plist"
        let fileManager = FileManager.default
        if(fileManager.fileExists(atPath: path)){
            let content:NSArray = NSArray.init(contentsOfFile: path)!
            return content as? [String]
        }else{
            self.writePlist(withName: name, data: [String]())
            
        }
        return nil
    }
    class func getSettingPlist(withName name: String) -> Dictionary<String, String>?
    {
        let path = applicationDocumentsDirectory() + "/\(name).plist"
        let fileManager = FileManager.default
        if(fileManager.fileExists(atPath: path)){
            let content:NSDictionary = NSDictionary.init(contentsOfFile: path) ?? [:]
            return content as? Dictionary<String, String>
        }else{
            self.writeSettings(withName: name, dictionary: [:])
            
        }
        return nil
    }
    
    
    class func writePlist(withName name: String, data: [String]){
        let filepath = applicationDocumentsDirectory() + "/\(name).plist"
        (data as NSArray).write(toFile: filepath, atomically: true)
    }
    
    class func writeSettings(withName name: String, dictionary: Dictionary<String, String>){
        let filepath = applicationDocumentsDirectory() + "/\(name).plist"
        (dictionary as NSDictionary).write(toFile: filepath, atomically: true)
    }
    
    class func saveContacts(){
        self.saveFavouritContacts()
        self.saveRecentContacts()
        
    }
    
    class func saveSettings(){
        self.writeSettings(withName: SETTINGSFILENAME, dictionary: AppPreference.sharedInstance.settings.toDict())
    }
    
    class func saveFavouritContacts(){
        let identifier = AppPreference.sharedInstance.favouritContacts.map { (contact) -> String in
            contact.identifier
        }
        self.writePlist(withName: FAVOURITCONTACTSFILENAME, data: identifier)
    }
    class func saveRecentContacts(){
        let identifier = AppPreference.sharedInstance.recentContacts.map { (contact) -> String in
            contact.identifier
        }
        self.writePlist(withName: RECENTCONTACTSFILENAME, data: identifier)
    }
}
