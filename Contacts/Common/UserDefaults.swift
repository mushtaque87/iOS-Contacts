//
//  UserDefaults.swift
//  Contacts
//
//  Created by Mushtaque Ahmed on 12/29/19.
//  Copyright © 2019 Mushtaque Ahmed. All rights reserved.
//

import Foundation

extension UserDefaults {
 
    func fetchHistoryFromDefault(for key:String) -> [String] {
        let history =  UserDefaults.standard.stringArray(forKey: key) ?? [String]()
        let newhistory  = Set(history.map({ $0 }))
        return Array(newhistory)
    }
    
   
    func setHistoryInDefault(for key:String , with value:String) {
        var history = UserDefaults.standard.fetchHistoryFromDefault(for: key)
        history.append(value)
        UserDefaults.standard.set(history, forKey: key)
    }
    
    
}
