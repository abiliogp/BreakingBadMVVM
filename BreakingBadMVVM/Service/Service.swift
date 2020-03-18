//
//  Service.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 20/01/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case unavailable
    case decodeError
}

class Service {

    private var urlSession: URLSession
    internal var cacheService: CacheService

    init(urlSession: URLSession = URLSession.shared,
         cacheService: CacheService = CacheService()) {
        self.urlSession = urlSession
        self.cacheService = cacheService
    }

    func fetchAndCache(folder: String,
                       file: String,
                       from url: URL,
                       completionHandler: @escaping (Result<Data, ServiceError>) -> Void) {

        do {
            if try cacheService.hasFile(named: file, folder: folder) {
                try cacheService.loadFile(named: file, folder: folder) { (data) in
                    completionHandler(.success(data))
                }
            } else {
                fetchFromServer(folder: folder,
                                file: file,
                                from: url,
                                completionHandler: completionHandler
                )
            }
        } catch {
            fetchFromServer(folder: folder,
                            file: file,
                            from: url,
                            completionHandler: completionHandler
            )
        }
    }

    func fetchFromServer(folder: String,
                         file: String,
                         from url: URL,
                         completionHandler: @escaping (Result<Data, ServiceError>) -> Void) {

        fetchFromServer(from: url) { (result) in
            switch result {
            case .success(let data):
                do {
                    completionHandler(.success(data))
                    try self.cacheService.saveFile(named: file, folder: folder, data: data)
                } catch {
                    completionHandler(.failure(.decodeError))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func fetchFromServer(from url: URL,
                         completionHandler: @escaping (Result<Data, ServiceError>) -> Void) {

        urlSession.dataTask(with: url) {(data, _, _) in
            if let data = data {
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(.unavailable))
            }
        }.resume()
    }

    func convertData<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }

}
