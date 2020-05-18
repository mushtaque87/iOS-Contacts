//
//  DetailTableViewCell.swift
//  Contacts
//
//  Created by Mushtaque Ahmed on 02/02/2020.
//  Copyright © 2020 Mushtaque Ahmed. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLable: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    weak var delegate: ContactDetailsTableCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        valueTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func editValue(edit:Bool =  false) {
        valueTextField.isEnabled = edit
    }
    
    func decorateCell(for type:String , value:String = ""  , isEditing : Bool = false , indexPath:IndexPath) {
        typeLable.text = type
        valueTextField.text = value
        valueTextField.isEnabled = isEditing
        valueTextField.tag = indexPath.row
    }
    
   
}

extension DetailTableViewCell : UITextFieldDelegate  {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.setCurrentTextField(textfield: textField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
           return true
       }
     
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.setValue(with: textField.text!, for: textField)
    }
}
