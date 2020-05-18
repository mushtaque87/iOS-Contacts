//
//  Decoder.swift
//  Contacts
//
//  Created by Mushtaque Ahmed on 12/24/19.
//  Copyright © 2019 Mushtaque Ahmed. All rights reserved.
//

import Foundation

class CustomDecoder {
    
    static func decodeData<T : Decodable>(_ data:Data? , of type:T.Type) throws -> Any? {
        do {
            let content  = try JSONDecoder().decode(type, from: data!)
            return content
        }
        catch let DecodingError.dataCorrupted(context) {
            print("Context:  \(context.debugDescription)")
            throw DecodingError.dataCorrupted(context) 
            
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key: \(key) context:  \(context.debugDescription)")
            throw DecodingError.keyNotFound(key, context)
            
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value: \(value) context:  \(context.debugDescription)")
            throw DecodingError.valueNotFound(value, context)
            
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type: \(type) context:  \(context.debugDescription)")
            throw DecodingError.typeMismatch(type, context)
            
        }
        catch {
            print("HTTP error: \(error.localizedDescription)")
            throw error
            
        }
    }
    
}
