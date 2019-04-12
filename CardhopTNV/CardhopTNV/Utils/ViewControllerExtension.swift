//
//  ViewController.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/12/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func showAlert(content: String){
        let alert = UIAlertController(title: nil, message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
           
        })
        self.present(alert, animated: true, completion: nil)
    }
    
}
