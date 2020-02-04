//
//  MockCharacterService.swift
//  BreakingBadMVVMTests
//
//  Created by Abilio Gambim Parada on 04/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation
@testable import BreakingBadMVVM

class MockCharacterService: CharacterServiceProtocol{
    
    var forceError = false
    var timesFetchCharacters = 0
    
    func fetchCharacters(completionHandler: @escaping (Result<[Character], ServiceError>) -> ()) {
        if forceError {
            completionHandler(.failure(.unavailable))
        } else{
            completionHandler(.success(GenerateCharacter().generate()))
        }
    }
    
    func fecthCharacter(with id: Int, completionHandler: @escaping (Result<Character, ServiceError>) -> ()) {
        
    }
    
    func clear(){
        forceError = false
        timesFetchCharacters = 0
    }
}

fileprivate class GenerateCharacter{
    
    func generate() -> [Character] {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "characters", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let characters = try! JSONDecoder().decode([Character].self, from: data)
        return characters
    }
}
