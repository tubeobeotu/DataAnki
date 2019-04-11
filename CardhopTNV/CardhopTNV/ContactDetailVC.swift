//
//  ContactDetailVC.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class ContactDetailVC: BaseViewController {
    @IBOutlet weak var cst_Top: NSLayoutConstraint!
    var contact:ContactModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let topBarHeight =
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        self.cst_Top.constant = -topBarHeight
        self.isShowLargeTitle = false
        self.isShowSiriView = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(showEditVC))
        // Do any additional setup after loading the view.
    }

    @objc func showEditVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "EditContactVC") as? EditContactVC{
            vc.contact = self.contact
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
