//
//  EditContactVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class EditContactVC: BaseViewController {
    var contact:ContactModel!
    var barButtonSave: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowLargeTitle = false
        self.isShowSiriView = false
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAction))
        barButtonSave = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveAction))
        barButtonSave.isEnabled = false
        self.navigationItem.rightBarButtonItem = barButtonSave
    }
    
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func saveAction(){
        self.dismiss(animated: true, completion: nil)
    }
    

}
