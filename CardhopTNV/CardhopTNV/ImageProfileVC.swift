//
//  ImageProfileVC.swift
//  CardhopTNV
//
//  Created by Nguyễn Văn Tú on 4/12/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
class ImageProfileVC: BaseViewController {
    var picture: UIImage?
    
    @IBOutlet weak var img_Profile: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowSiriView = false
        isShowLargeTitle = false
        self.img_Profile.image = self.picture
        self.img_Profile.contentMode = .scaleAspectFit
    }
}

