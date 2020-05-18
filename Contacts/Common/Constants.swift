//
//  Constants.swift
//  Contacts
//
//  Created by Mushtaque Ahmed on 12/21/19.
//  Copyright © 2019 Mushtaque Ahmed. All rights reserved.
//

import Foundation

import Foundation

struct Constants {
    
    struct ServerApi {
        //All the micro service APIs can be kept at one place.
        static let baseUrl = "http://gojek-contacts-app.herokuapp.com"
        static let getContacts = baseUrl + "/contacts.json"
        static let getContactDetails = baseUrl +  "/contacts/%d.json"
    }
}
