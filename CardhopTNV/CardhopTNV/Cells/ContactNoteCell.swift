//
//  ContactNoteCell.swift
//  CardhopTNV
//
//  Created by Tu on 4/11/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit
protocol ContactNoteCellDelegate{
    func didChangeNote(content: String)
    func changeNote(content: String, cell: UITableViewCell)
}
class ContactNoteCell: BaseTableViewCell {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var tv_Content: UITextView!
    
    @IBOutlet weak var btn_Icon: UIButton!
    var delegate:ContactNoteCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btn_Icon.tintColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.lbl_Title.textColor = AppPreference.sharedInstance.settings.appBgMode.cellContentTextColor
        self.tv_Content.textColor = AppPreference.sharedInstance.settings.appBgMode.cellTitleTextColor
        self.tv_Content.delegate = self
        self.tv_Content.layer.borderWidth = 1
        let color = AppPreference.sharedInstance.settings.appBgMode.cellContentTextColor
        self.tv_Content.layer.borderColor = color.cgColor
        self.tv_Content.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension ContactNoteCell: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.didChangeNote(content: textView.text)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.tv_Content.isScrollEnabled = true
        self.delegate?.changeNote(content: text, cell: self)
        return true
    }
}
