//
//  DataManager.swift
//  Contacts
//
//  Created by Mushtaque Ahmed on 12/22/19.
//  Copyright © 2019 Mushtaque Ahmed. All rights reserved.
//

import Foundation

enum MoveArticle  {
    case next
    case previous
}

struct CurrentContact {
    var currentIndex : Int?
    var currentContact : Contact?
}

protocol DataDelegate {
    
    associatedtype D
    var contacts : [D] {get set}
    func appendData(with data:[D])
    func cleanAllData()
    func getContact(for index:Int) -> D?
    func getCurrentIndex() -> Int
    func setNextIndex(_ moveTo:MoveArticle)
    func setCurrentIndex(_ index: Int)
    func getContactCount() -> Int
    func getCurrentContact() -> CurrentContact

}

class Datamanager : NSObject , DataDelegate {
    
    typealias D = Contact
    var contacts = [D]()
    var currentIndex = 0
    
    override init() {
        super.init()
    }
    
    
    func appendData(with data: [Contact]) {
        self.contacts.append(contentsOf: data)
    }
    
    func getContact(for index:Int) -> D? {
        guard (0..<self.contacts.count).contains(index) else {
            return nil
        }
        return self.contacts[index]
    }
    func cleanAllData() {
        self.contacts.removeAll()
    }
    
    func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    func setCurrentIndex(_ index: Int) {
        self.currentIndex = index
    }
    func setNextIndex(_ moveTo:MoveArticle) {
        switch moveTo {
        case .next:
            guard currentIndex == self.contacts.count else {
                return
            }
            currentIndex += 1
            
        default:
            guard currentIndex > 0 else {
                return
            }
            currentIndex += -1
        }
    }
    
    func getContactCount() -> Int {
        self.contacts.count
    }
    
    func getCurrentContact() -> CurrentContact { 
           return CurrentContact(currentIndex: currentIndex, currentContact: getContact(for: currentIndex))
       }
    
}
