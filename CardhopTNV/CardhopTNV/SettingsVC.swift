//
//  SettingsVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/3/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
import CountryPickerView
class SettingsVC: BaseViewController {

    @IBOutlet weak var v_Theme: ThemeView!
    let cpvInternal = CountryPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPickerCountry()
        // Do any additional setup after loading the view.
    }
    func setupPickerCountry(){
        cpvInternal.dataSource = self
        cpvInternal.delegate = self
        cpvInternal.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.cpvInternal.showCountriesList(from: self.navigationController!)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension SettingsVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        print(message)
    }
    func countryPickerView(_ countryPickerView: CountryPickerView, willShow viewController: UITableViewController) {
        viewController.view.backgroundColor = AppPreference.sharedInstance.getAppBgColor()
        viewController.tableView.backgroundColor = AppPreference.sharedInstance.getAppBgColor()
    }

}

extension SettingsVC: CountryPickerViewDataSource {
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .hidden
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return cpvInternal.showPhoneCodeInView 
    }

}
