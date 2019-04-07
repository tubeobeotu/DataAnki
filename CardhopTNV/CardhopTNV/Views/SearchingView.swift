//
//  SearchingView.swift
//  CardhopTNV
//
//  Created by Tu on 4/6/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
enum SearchingViewType:Int {
    case UnAction = 0
    case Action = 1
}
protocol SearchingViewDelegate{
    func showSearchingVC()
    func showSiri()
}
class SearchingView: BaseCustomNibView {
    var viewType:SearchingViewType = .UnAction{
        didSet{
            if(viewType == .UnAction){
                self.btn_ShowSearch.isHidden = false
                self.tf_Search.isUserInteractionEnabled = false
            }else{
                self.btn_ShowSearch.isHidden = true
                self.tf_Search.isUserInteractionEnabled = true
            }
        }
    }
    @IBOutlet weak var btn_ShowSearch: UIButton!
    @IBOutlet weak var tf_Search: UITextField!
    @IBOutlet weak var btn_Search: UIButton!
    var delegate:SearchingViewDelegate?
    override func setupViews() {
        self.tf_Search.placeholder = "Cardhop"
        self.tf_Search.delegate = self
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true

    }
    @IBAction func search(_ sender: Any) {
        self.delegate?.showSiri()
    }
    @IBAction func showSearchingVC(_ sender: Any) {
        self.delegate?.showSearchingVC()
    }
    
}

extension SearchingView: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
