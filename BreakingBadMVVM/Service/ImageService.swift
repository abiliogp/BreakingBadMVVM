//
//  ImageService.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 05/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation
import UIKit

protocol ImageServiceProtocol {
    func fetchImage(from url: String, completionHandler: @escaping (Result<UIImage, ServiceError>) -> Void)
}

struct ImageService {

    private let service: Service
    private let cacheService: CacheService

    private let folderNamed = Files.Folder.images

    init(service: Service = Service(),
         cacheService: CacheService = CacheService()) {
        self.service = service
        self.cacheService = cacheService
    }
}

extension ImageService: ImageServiceProtocol {

    func fetchImage(from url: String,
                    completionHandler: @escaping (Result<UIImage, ServiceError>) -> Void) {
        guard let imgUrl = URL(string: url) else { return }

        let fileNamed = self.cacheService.extractFileName(input: imgUrl.path)

        service.fetchAndCache(folder: folderNamed,
                              file: fileNamed,
                              from: imgUrl) { result in
                                switch result {
                                case .success(let data):
                                    if let image = UIImage(data: data) {
                                        completionHandler(.success(image))
                                    } else {
                                        completionHandler(.failure(.decodeError))
                                    }
                                case .failure(let error):
                                    completionHandler(.failure(error))
                                }
        }
    }

}
