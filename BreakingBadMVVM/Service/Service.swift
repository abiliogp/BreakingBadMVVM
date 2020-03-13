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

struct Service {

    private var urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetchAndCache(folder: String,
                       file: String,
                       from url: URL,
                       completionHandler: @escaping (Result<Data, ServiceError>) -> Void) {

        do {
            if try CacheService().hasFile(named: file, folder: folder) {
                try CacheService().loadFile(named: file, folder: folder) { (data) in
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
                    try CacheService().saveFile(named: file, folder: folder, data: data)
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
