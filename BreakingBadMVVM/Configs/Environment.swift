//
//  Environment.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 03/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

public enum Environment{
    
    private static let infoDictionary: [String: Any] = {
      guard let dict = Bundle.main.infoDictionary else {
        fatalError("Plist file not found")
      }
      return dict
    }()
    
    static let BASE_URL: String = {
      guard let baseUrl = Environment.infoDictionary["BASE_URL"] as? String else {
        fatalError("API Key not set in plist for this environment")
      }
      return baseUrl
    }()
    
    static let ENDPOINT_CHARACTERS: String = {
      guard let endpointCharacters = Environment.infoDictionary["ENDPOINT_CHARACTERS"] as? String else {
        fatalError("API Key not set in plist for this environment")
      }
      return endpointCharacters
    }()
}
