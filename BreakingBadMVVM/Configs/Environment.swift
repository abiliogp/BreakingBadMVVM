//
//  Environment.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 03/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

public enum Environment {

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    private static func getValueForKey(key: String) -> String {
        guard let value = Environment.infoDictionary[key] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return value
    }
}

extension Environment {

    static let baseUrl: String = {
        return getValueForKey(key: Keys.Plist.baseUrl)
    }()

    static let endpointCharacters: String = {
        return getValueForKey(key: Keys.Plist.endpointCharacters)
    }()

    static let titleApp: String = {
        return getValueForKey(key: Keys.Plist.titleApp)
    }()

}
