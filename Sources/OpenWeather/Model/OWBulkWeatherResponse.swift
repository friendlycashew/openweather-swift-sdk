//
//  OWBulkWeatherResponse.swift
//  
//
//  Created by Adil Erchouk on 11/4/22.
//

import Foundation

struct OWBulkWeatherResponse: Codable {

    /// The list of weather response.
    let list: [OWSimpleWeatherResponse]
    
    /// Response status
    ///
    /// - Note: Unlike for the simple weather response, the Open Weather API provides here a `String` for the response code instead of an `Int`
    let responseCode: String
    
    /// Message used for error descriptions.
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case list, message
        case responseCode = "cod"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let responseCode = try values.decode(String.self, forKey: .responseCode)
        
        if responseCode != "200" {
            // If response code is different than 200, it's an error
            let errorMessage = try? values.decode(String.self, forKey: .message)
            throw OWError(errorCode: Int(responseCode) ?? -1, message: errorMessage)
        }
        
        list = try values.decode([OWSimpleWeatherResponse].self, forKey: .list)
        self.responseCode = responseCode
        self.message = try? values.decode(String.self,
                                          forKey: .message)
    }
}