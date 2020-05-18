//
//  NetworkManager.swift
//  Contacts
//
//  Created by Mushtaque Ahmed on 12/21/19.
//  Copyright © 2019 Mushtaque Ahmed. All rights reserved.
//

import Foundation



class NetworkManager : NSObject {
    let httpClient : HttpClient
    
    init(httpClient:HttpClient) {
        self.httpClient = httpClient
    }
    
    func fetchContacts(_ url: URL,
                       onSuccess successCompletionHandler: @escaping ([Contact]) -> Void,
                       onFailure: @escaping(Error) -> Void) {
        httpClient.get(url: url) { (data , response , error) in
            if error != nil  {
                onFailure(error!)
            } else {
                
                do {
                    var contacts : [Contact] = try CustomDecoder.decodeData(data, of: [Contact].self) as! [Contact]
                    
                    //                    // Sort the array
                    //                    contacts.sort {
                    //                        $0.first_name! < $1.first_name!
                    //                    }
                    //
                    successCompletionHandler(contacts)
                    
                } catch  {
                    print("Throwable Error \(error)")
                    
                }
            }
        }
        
    }
     /* Fetch Contacts Network Call */
    func fetchContactDetails(_ url: URL,
                             onSuccess successCompletionHandler: @escaping (ContactDetails) -> Void,
                             onFailure: @escaping(HTTPError) -> Void) {
        httpClient.get(url: url) { (data , response , error) in
            if error != nil  {
                onFailure(HTTPError(with:[error!.localizedDescription]))
            } else {
                if let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 {
                    do {
                        let contactDetails : ContactDetails = try CustomDecoder.decodeData(data, of: ContactDetails.self) as! ContactDetails
                        successCompletionHandler(contactDetails)
                        
                    } catch  {
                        print("Throwable Error \(error)")
                        
                    }
                } else {
                    do {
                        let error : HTTPError = try CustomDecoder.decodeData(data, of: HTTPError.self) as! HTTPError
                        onFailure(error)
                        
                    } catch  {
                        print("Throwable Error \(error)")
                    }
                }
            }
        }
    }
     /* Add Contact Network Call */
    func addContacts(_ url: URL,
                     parameters : [String:Any],
                     onSuccess successCompletionHandler: @escaping (ContactDetails) -> Void,
                     onFailure: @escaping(HTTPError) -> Void) {
        httpClient.post(url: url, parameters: parameters) { (data , response , error) in
            if error != nil  {
                onFailure(HTTPError(with:[error!.localizedDescription]))
            } else {
                if let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 | 201 {
                    do {
                        let contactDetails : ContactDetails = try CustomDecoder.decodeData(data, of: ContactDetails.self) as! ContactDetails
                        successCompletionHandler(contactDetails)
                        
                    } catch  {
                        print("Throwable Error \(error)")
                    }
                } else {
                    do {
                        let error : HTTPError = try CustomDecoder.decodeData(data, of: HTTPError.self) as! HTTPError
                        onFailure(error)
                        
                    } catch  {
                        print("Throwable Error \(error)")
                    }
                }
            }
        }
        
    }
    /* Update Contact Network Call */
    func updateContacts(_ url: URL,
                        parameters : [String:Any],
                        onSuccess successCompletionHandler: @escaping (ContactDetails) -> Void,
                        onFailure: @escaping(HTTPError) -> Void) {
        httpClient.put(url: url, parameters: parameters) { (data , response , error) in
            if error != nil  {
                onFailure(HTTPError(with:[error!.localizedDescription]))
            } else {
                if let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 {
                    do {
                        let contactDetails : ContactDetails = try CustomDecoder.decodeData(data, of: ContactDetails.self) as! ContactDetails
                        successCompletionHandler(contactDetails)
                        
                    } catch  {
                        print("Throwable Error \(error)")
                        
                    }
                } else {
                    do {
                        let error : HTTPError = try CustomDecoder.decodeData(data, of: HTTPError.self) as! HTTPError
                        onFailure(error)
                        
                    } catch  {
                        print("Throwable Error \(error)")
                    }
                }
            }
        }
        
    }
}
