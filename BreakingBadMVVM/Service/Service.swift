//
//  Service.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 20/01/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

protocol CharacterServiceProtocol {
    func fetchCharacters(completionHandler: @escaping (Result<[Character], ServiceError>) -> Void)
}

enum ServiceError: Error {
    case unavailable
    case decodeError
}

struct Service {

    static let shared = Service()

    private let baseURL = Environment.baseUrl
    private let endPointCharacters = Environment.endpointCharacters

    private let folderNamed = Files.Folder.characters
    private let fileNamed = Files.Payload.characters

    private init() {}

}

extension Service: CharacterServiceProtocol {

    func fetchCharacters(completionHandler: @escaping (Result<[Character], ServiceError>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endPointCharacters)") else { return }

        do {
            if try CacheService.shared.hasFile(named: fileNamed, folder: folderNamed) {

                try CacheService.shared.loadFile(named: fileNamed, folder: folderNamed) { (data) in
                    self.convertData(data: data) { (result) in
                        completionHandler(result)
                    }
                }
            } else {
                fetchFromServer(from: url) { (result) in
                    completionHandler(result)
                }
            }
        } catch {
            fetchFromServer(from: url) { (result) in
                completionHandler(result)
            }
        }

    }

    func fetchFromServer(from url: URL, completionHandler: @escaping (Result<[Character], ServiceError>) -> Void) {
        URLSession.shared.dataTask(with: url) {(data, _, _) in
            DispatchQueue.main.async {

                if let data = data {
                    do {
                        let characters = try JSONDecoder().decode([Character].self, from: data)
                        completionHandler(.success(characters))
                        try CacheService.shared.saveFile(named: self.fileNamed, folder: self.folderNamed, data: data)
                    } catch {
                        completionHandler(.failure(.decodeError))
                    }
                } else {
                    completionHandler(.failure(.unavailable))
                }
            }
        }.resume()
    }

    private func convertData(data: Data, completionHandler: @escaping (Result<[Character], ServiceError>) -> Void) {
        do {
            let characters = try JSONDecoder().decode([Character].self, from: data)
            completionHandler(.success(characters))
        } catch {
            completionHandler(.failure(.decodeError))
        }
    }

}
