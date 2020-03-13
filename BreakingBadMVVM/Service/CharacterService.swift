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

struct CharacterService {

    private let service: Service
    private let cacheService: CacheService

    private let baseURL = Environment.baseUrl
    private let endPointCharacters = Environment.endpointCharacters

    private let folderNamed = Files.Folder.characters
    private let fileNamed = Files.Payload.characters

    init(service: Service = Service(),
         cacheService: CacheService = CacheService()) {
        self.service = service
        self.cacheService = cacheService
    }
}

extension CharacterService: CharacterServiceProtocol {

    func fetchCharacters(completionHandler: @escaping (Result<[Character], ServiceError>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endPointCharacters)") else { return }

        service.fetchAndCache(folder: folderNamed,
                              file: fileNamed,
                              from: url) { result in
                                switch result {
                                case .success(let data):
                                    do {
                                        let converted = try self.service.convertData(data: data) as [Character]
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
