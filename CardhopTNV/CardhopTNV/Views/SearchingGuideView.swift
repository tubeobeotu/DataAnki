//
//  SearchingGuideView.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/10/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

enum SearchingGuideViewType:Int {
    case Name = 0
    case Phone = 1
    case Email = 2
    case Address = 3
    var text: String{
        get{
            switch(self){
            case .Name: return "Search with Name"
            case .Phone: return "Search with Phone"
            case .Email: return "Search with Email"
            case .Address: return "Search with Address"
            }
        }
    }
    
    var imageName: String{
        get{
            switch(self){
            case .Name: return "name"
            case .Phone: return "phone"
            case .Email: return "email"
            case .Address: return "address"
            }
        }
    }
}


class SearchingGuideView: BaseCustomNibView {
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var v_Name: SearchingGuideOptionView!
    
    @IBOutlet weak var v_Phone: SearchingGuideOptionView!
    
    @IBOutlet weak var v_Email: SearchingGuideOptionView!
    
    @IBOutlet weak var v_Address: SearchingGuideOptionView!
    
    override func setupViews() {
        self.lbl_Title.textColor = AppPreference.sharedInstance.settings.appBgMode.sectionTextColor
        self.v_Name.type = .Name
        self.v_Email.type = .Email
        self.v_Phone.type = .Phone
        self.v_Address.type = .Address
    }
}
