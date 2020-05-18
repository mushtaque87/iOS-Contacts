//
//  ContactViewModel.swift
//  Contacts
//
//  Created by Mushtaque Ahmed on 30/01/2020.
//  Copyright © 2020 Mushtaque Ahmed. All rights reserved.
//

import Foundation
import UIKit



class ContactViewModel : NSObject {
    
    let networkManager : NetworkManager
    let dataManager : Datamanager
    weak var delegate: ContactListVCDelegate?
    var numberOfRowsforSectionOne = 0
    lazy var histories = [String]()
    
    init(networkManager : NetworkManager , dataManager:Datamanager) {
        self.networkManager = networkManager
        self.dataManager = dataManager
    }
    
    /*
    func generateURL(with searchText:String = "") -> URL {
        var encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        return URL(string:String(format: searchText.count == 0 ? "%@" : "%@&%@",  Constants.ServerApi.baseUrl+Constants.KEY,"q=\(encodedSearchText)&page=0"))!
    }
    
    func search(for text:String) {
        let url = generateURL(with: text)
        self.networkManager.search(url , onSuccess: { docs in
            
            self.dataManager.appendData(with: docs)
            DispatchQueue.main.async {
                self.delegate?.reloadTableView()
            }
        }, onFailure: { error in
            print("Error \(error)")
        })
    }
 */
    
    
    @objc func fetchContacts() {
        let url = URL(string:Constants.ServerApi.getContacts)!
        
        self.networkManager.fetchContacts(url , onSuccess: { contact in
                   self.dataManager.cleanAllData()
                   self.dataManager.appendData(with: contact)
                   DispatchQueue.main.async {
                       self.delegate?.reloadTableView()
                   }
               }, onFailure: { error in
                   print("Error \(error)")
               })
    }
    
}


extension ContactViewModel : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100 // The cell has to be dynamic based on the asbtract text count.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataManager.getContactCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
            if let contact = self.dataManager.getContact(for: indexPath.row) {
                cell.headlineLabel.text = (contact.first_name ?? "") + " " + (contact.last_name ?? "")
                cell.favImageView.image = contact.favorite ?? false ? UIImage(named: "home_favourite") : nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if let contact = self.dataManager.getContact(for: indexPath.row) {
            delegate?.showDetailPageVC(contact)
         }
        }
}

