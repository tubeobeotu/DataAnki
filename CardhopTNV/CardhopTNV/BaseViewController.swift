//
//  BaseViewController.swift
//  CardhopTNV
//
//  Created by Tu on 4/3/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var isShowSiriView = true
    var isShowLargeTitle = true
    @IBOutlet weak var tbl_Content: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationItem.largeTitleDisplayMode = .always
        }
        self.tbl_Content?.separatorStyle = .none
        self.tbl_Content?.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    
        self.changeBgView()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(changeBgView),
                                       name: .appBgMode,
                                       object: nil)
        self.view.constraint(withIdentifier: "BottomConstraint")?.constant = AppPreference.sharedInstance.searchViewHeight + AppPreference.sharedInstance.marginSearchView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadModels()
        self.reloadData()
        AppPreference.sharedInstance.siriView.isHidden = !self.isShowSiriView
        self.navigationController?.navigationBar.prefersLargeTitles = self.isShowLargeTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func changeBgView(){
        self.view.backgroundColor = AppPreference.sharedInstance.getAppBgColor()
        AppPreference.sharedInstance.changeNavMode(nav: self.navigationController)
        self.reloadData()
    }
    
    func reloadData(){
        self.tbl_Content?.reloadData()
    }
    func reloadModels(){
        
    }
    
    func didSelectContactAtVC(contact: ContactModel) {
        
    }
    func showSearchingVC(isShowGuide: Bool = false){
        if let nav = self.getSearchingNav(isShowGuide: isShowGuide){
            let controller = self.getSearchingVCFrom(nav: nav, isShowGuide: isShowGuide)
            controller?.delegate = self
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    func showContactDetailVC(contact: ContactModel){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ContactDetailVC") as? ContactDetailVC{
            vc.contact = contact
            self.navigationController?.navigationBar.prefersLargeTitles = false
           self.navigationController?.pushViewController(vc, animated:  true)
        }
    }
}

extension BaseViewController: SearchingContactsVCDelegate{
    func didSelectContact(contact: ContactModel) {
        self.didSelectContactAtVC(contact: contact)
    }
}


extension UIView {
    func constraint(withIdentifier: String) -> NSLayoutConstraint? {
        return self.constraints.filter { $0.identifier == withIdentifier }.first
    }
}

extension UIViewController{
    func getSearchingNav(isShowGuide: Bool = false) -> UINavigationController?{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nav = storyboard.instantiateViewController(withIdentifier: "NavSearchingContactVC") as? UINavigationController{
            return nav
        }
        
        return nil
    }
    func getSearchingVCFrom(nav: UINavigationController, isShowGuide: Bool = false) -> SearchingContactsVC?{
        if let controller = nav.viewControllers.first as? SearchingContactsVC{
            controller.isShowGuide = isShowGuide
            return controller
        }
        return nil
    }

}
