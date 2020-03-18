//
//  CharacterService.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 13/03/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

protocol CharacterServiceProtocol {
    func fetchCharacters(completionHandler: @escaping (Result<[Character], ServiceError>) -> Void)
}

class CharacterService: Service {

}

extension CharacterService: CharacterServiceProtocol {

    func fetchCharacters(completionHandler: @escaping (Result<[Character], ServiceError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseUrl)\(Environment.endpointCharacters)") else { return }

        fetchAndCache(folder: Files.Folder.characters,
                      file: Files.Payload.characters,
                      from: url) { result in
                        switch result {
                        case .success(let data):
                            do {
                                let converted = try self.convertData(data: data) as [Character]
                                completionHandler(.success(converted))
                            } catch {
                                completionHandler(.failure(.decodeError))
                        }

                        case .failure(let error):
                            completionHandler(.failure(error))
                        }
        }
    }

}
