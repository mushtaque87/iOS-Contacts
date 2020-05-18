//
//  ContactsTests.swift
//  ContactsTests
//
//  Created by Mushtaque Ahmed on 30/01/2020.
//  Copyright © 2020 Mushtaque Ahmed. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactsTests: XCTestCase {
    var sut: NetworkManager!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let url = URL(string:Constants.ServerApi.getContacts)!
        let urlResponse = HTTPURLResponse(
                  url: url,
                  statusCode: 200,
                  httpVersion: nil,
                  headerFields: nil)
              
              let data = Helper.readJsonFile(at: "Contacts", ofType: ".json")
              let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
              sut = NetworkManager(httpClient: HttpClient(session: sessionMock))
    }

    func testGetContactsAPI_UsingMock() {
        
        let promise = expectation(description: "Status Code: 200")
        let url = URL(string:Constants.ServerApi.getContacts)!

        let dataTask = sut.httpClient.session.dataTask(with: url) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 {
                do {
                    let contacts : [Contact] = try CustomDecoder.decodeData(data, of: [Contact].self) as! [Contact]
                                 print("Contacts \(contacts)")
                    XCTAssertTrue(contacts.count > 0)
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
    
    func testJsonDecoding() {
           
           let data = Helper.readJsonFile(at: "Contacts", ofType: ".json")
           do {
               let contacts : [Contact] = try CustomDecoder.decodeData(data, of: [Contact].self) as! [Contact]
               print("Contacts \(contacts)")
               XCTAssertEqual(contacts[0].first_name, "Abel" , "Contact firstName is \(contacts[0].first_name)")
               
           } catch  {
               print("Throwable Error \(error)")
               XCTFail("Throwable Error \(error)")
           }
       }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut =  nil
        super.tearDown()
    }

  

}
