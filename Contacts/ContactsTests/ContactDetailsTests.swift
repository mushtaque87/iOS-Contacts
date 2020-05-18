//
//  ContactDetailsTests.swift
//  ContactsTests
//
//  Created by Mushtaque Ahmed on 01/02/2020.
//  Copyright © 2020 Mushtaque Ahmed. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactDetailsTests: XCTestCase {
    var sut: NetworkManager!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let url = URL(string:String(format: Constants.ServerApi.getContactDetails , "16267"))!
        
        let urlResponse = HTTPURLResponse(
                  url: url,
                  statusCode: 200,
                  httpVersion: nil,
                  headerFields: nil)
              
              let data = Helper.readJsonFile(at: "ContactDetails", ofType: ".json")
              let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
              sut = NetworkManager(httpClient: HttpClient(session: sessionMock))
    }
    
    func testGetContactDetailsAPI_UsingMock() {
           
           let promise = expectation(description: "Status Code: 200")
           //let url = URL(string:Constants.ServerApi.getContacts)!
        let url = URL(string:String(format: Constants.ServerApi.getContactDetails , "16267"))!


           let dataTask = sut.httpClient.session.dataTask(with: url) {
               data, response, error in
               if let error = error {
                   print(error.localizedDescription)
               } else if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 {
                   do {
                       let contactdetails : ContactDetails = try CustomDecoder.decodeData(data, of: ContactDetails.self) as! ContactDetails
                                    print("Contacts \(contactdetails)")
                       XCTAssertTrue(contactdetails.id == 16267)
                   } catch  {
                       print("Throwable Error \(error)")
                       XCTFail("Throwable Error \(error)")
                   }
               }
               promise.fulfill()
           }
           dataTask.resume()
           wait(for: [promise], timeout: 15)
      
       }
    
    func testAddContactAPI_UsingMock() {
         
        let promise = expectation(description: "Status Code: 200")
         //let url = URL(string:Constants.ServerApi.getContacts)!
        let url = URL(string:Constants.ServerApi.getContacts)!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "first_name": "AA1",
            "last_name": "AA1",
            "email" : "ab@bachchan.com",
            "phone_number" : "+919980123412",
            "favorite" : true
        ]
        do {
              request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
          } catch let error {
              print(error.localizedDescription)
          }
        
        let dataTask = sut.httpClient.session.dataTask(with: request) {
             data, response, error in
             if let error = error {
                 print(error.localizedDescription)
             } else if let httpResponse = response as? HTTPURLResponse,
                 httpResponse.statusCode == 200 {
                 do {
                     let contactdetails : ContactDetails = try CustomDecoder.decodeData(data, of: ContactDetails.self) as! ContactDetails
                                  print("Contacts \(contactdetails)")
                     XCTAssertTrue(contactdetails.id == 16267)
                 } catch  {
                     print("Throwable Error \(error)")
                     XCTFail("Throwable Error \(error)")
                 }
             }
             promise.fulfill()
         }
         dataTask.resume()
         wait(for: [promise], timeout: 15)
    
     }
    
    func testEditContactAPI_UsingMock() {
         
        let promise = expectation(description: "Status Code: 200")
         //let url = URL(string:Constants.ServerApi.getContacts)!
        //let url = URL(string:Constants.ServerApi.getContactDetails)!
        let url = URL(string:String(format: Constants.ServerApi.getContactDetails , "16358"))!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let parameters: [String: Any] = [
            "first_name": "AA1",
            "last_name": "AA1",
            "email" : "ab@bachchan.com",
            "phone_number" : "+919980123412",
            "favorite" : true
        ]
        do {
              request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
          } catch let error {
              print(error.localizedDescription)
          }
        
        let dataTask = sut.httpClient.session.dataTask(with: request) {
             data, response, error in
             if let error = error {
                 print(error.localizedDescription)
             } else if let httpResponse = response as? HTTPURLResponse,
                 httpResponse.statusCode == 200 {
                 do {
                     let contactdetails : ContactDetails = try CustomDecoder.decodeData(data, of: ContactDetails.self) as! ContactDetails
                                  print("Contacts \(contactdetails)")
                     XCTAssertTrue(contactdetails.id == 16267)
                 } catch  {
                     print("Throwable Error \(error)")
                     XCTFail("Throwable Error \(error)")
                 }
             }
             promise.fulfill()
         }
         dataTask.resume()
         wait(for: [promise], timeout: 15)
    
     }


    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut =  nil
        super.tearDown()
    }


}
