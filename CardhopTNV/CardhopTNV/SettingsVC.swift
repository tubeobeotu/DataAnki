//
//  SettingsVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/3/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class SettingsVC: BaseViewController {
    var isSelectType:OptionIndexType = .SortBy
    @IBOutlet weak var v_Theme: ThemeView!

    @IBOutlet weak var v_settingGeneral: SettingGeneralView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.v_settingGeneral.delegate = self
        // Do any additional setup after loading the view.
    }
    func showPickCountryVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ContactCountryVC") as? ContactCountryVC{
            vc.isSelectType = self.isSelectType
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
       
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension SettingsVC: SettingGeneralViewDelegate{
    func didSelectOption(type: OptionIndexType) {
        isSelectType = type
        if(type == .AddressFormat){
            self.showPickCountryVC()
        }else if(type == .DefaultCountryCode){
            self.showPickCountryVC()
        }
    }
}


