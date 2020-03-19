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
}

extension Service {
    private func fetchFromServer(folder: String,
                                 file: String,
                                 from url: URL,
                                 completionHandler: @escaping (Result<Data, ServiceError>) -> Void) {

        urlSession.dataTask(with: url) {(data, _, _) in
            if let data = data {
                do {
                    completionHandler(.success(data))
                    try self.cacheService.saveFile(named: file, folder: folder, data: data)
                } catch {
                    completionHandler(.failure(.decodeError))
                }

            } else {
                completionHandler(.failure(.unavailable))
            }
        }.resume()
    }
}

extension Service {
    internal func fetchAndCache(folder: String,
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

    internal func convertData<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
