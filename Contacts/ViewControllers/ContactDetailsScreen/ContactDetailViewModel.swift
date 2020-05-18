//
//  ContactDetailViewModel.swift
//  Contacts
//
//  Created by Mushtaque Ahmed on 02/02/2020.
//  Copyright © 2020 Mushtaque Ahmed. All rights reserved.
//

import UIKit

struct ContactToSave {
    var first_name : String?
    var last_name : String?
    var email : String?
    var phone_number : String?
    var profile_pic : String?
    var favorite : Bool?
}
class ContactDetailViewModel: NSObject  , ContactDetailsTableCellDelegate {
    
    
    var contactToShow : Contact?
    var  contactDetails : ContactDetails?
    var isEditing =  false
    let networkManager : NetworkManager
    let dataManager : Datamanager
    weak var delegate: ContactDetailsVCDelegate?
    var numberOfRowsforSectionOne = 0
    lazy var histories = [String]()
    var currentTextField : UITextField?
    var contactToSave = ContactToSave(first_name: "", last_name: "", email: "", phone_number: "", profile_pic: "", favorite:   false)
    var favContact : Bool = false
    
    init(networkManager : NetworkManager , dataManager:Datamanager) {
        self.networkManager = networkManager
        self.dataManager = dataManager
    }
    
    
    func fetchContactDetails() {
        let url = URL(string:String(format: Constants.ServerApi.getContactDetails , contactToShow?.id ?? 0))!
        
        self.networkManager.fetchContactDetails(url , onSuccess: { details in
            self.contactDetails = details
            self.contactToSave = ContactToSave(first_name: self.contactDetails?.first_name, last_name: self.contactDetails?.last_name , email: self.contactDetails?.email , phone_number: self.contactDetails?.phone_number , profile_pic: "", favorite:   self.contactDetails?.favorite)
            
            DispatchQueue.main.async {
                self.delegate?.reloadTableView()
                self.delegate?.updateUI()
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                self.delegate?.showNetworkErrorMessage(with: error)
                print("Error \(error)")
            }
        })
    }
    
    func addContact(with parameters:[String: Any]) {
        let url = URL(string:Constants.ServerApi.getContacts)!
        
        self.networkManager.addContacts(url, parameters: parameters  , onSuccess: { details in
            self.contactDetails = details
            DispatchQueue.main.async {
                self.delegate?.reloadTableView()
                self.delegate?.popVc()
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                self.delegate?.showNetworkErrorMessage(with: error)
                print("Error \(error)")
            }
        })
    }
    
    
    func updateContactDetails(with parameters:[String: Any]) {
        let url = URL(string:String(format: Constants.ServerApi.getContactDetails , contactToShow?.id ?? 0))!
        
        self.networkManager.updateContacts(url, parameters: parameters  , onSuccess: { details in
            self.contactDetails = details
            DispatchQueue.main.async {
                self.delegate?.reloadTableView()
                self.delegate?.popVc()
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                self.delegate?.showNetworkErrorMessage(with: error)
                print("Error \(error)")
            }
        })
    }
    
}


extension ContactDetailViewModel : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isEditing) {
            return 4
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell
        cell.delegate = self as? ContactDetailsTableCellDelegate
        var type = ""
        var value = ""
        
        if(isEditing){
            switch indexPath.row {
            case 0:
                type = "First Name"
                value = contactDetails?.first_name ?? ""
                break
            case 1:
                type = "Last Name"
                value = contactDetails?.last_name ?? ""
                break
            case 2:
                type = "mobile"
                value = contactDetails?.phone_number ?? ""
                break
            default:
                type = "email"
                value = contactDetails?.email ?? ""
            }
        } else {
            switch indexPath.row {
            case 0:
                type = "mobile"
                value = contactDetails?.phone_number ?? ""
                break
            default:
                type = "email"
                value = contactDetails?.email ?? ""
            }
        }
        cell.decorateCell(for:  type , value: value , isEditing: isEditing , indexPath: indexPath)
        return cell
    }
    
    func setCurrentTextField(textfield: UITextField) {
        self.currentTextField = textfield
    }
    
    func setValue(with value: String, for textfield: UITextField) {
        switch textfield.tag {
        case 0:
            self.contactToSave.first_name = value
            break
        case 1:
            self.contactToSave.last_name = value
            break
        case 2:
            self.contactToSave.phone_number = value
            break
        default:
            self.contactToSave.email = value
            break
        }
    }
    
}
