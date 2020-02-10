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

class ImageService {

    static let shared = ImageService()

    private let folderNamed = Files.Folder.images

    private init() {}
}

extension ImageService: ImageServiceProtocol {

    func fetchImage(from url: String,
                    completionHandler: @escaping (Result<UIImage, ServiceError>) -> Void) {
        guard let imgUrl = URL(string: url) else { return }

        let fileNamed = CacheService.shared.extractFileName(input: imgUrl.path)

        do {
            if try CacheService.shared.hasFile(named: fileNamed, folder: folderNamed) {

                try CacheService.shared.loadFile(named: fileNamed, folder: folderNamed) { (data) in
                    if let image = UIImage(data: data) {
                        completionHandler(.success(image))
                    }
                }
            } else {
                fetchFromServer(from: imgUrl, fileNamed: fileNamed) { (result) in
                    completionHandler(result)
                }
            }
        } catch {
            fetchFromServer(from: imgUrl, fileNamed: fileNamed) { (result) in
                completionHandler(result)
            }
        }

    }

    func fetchFromServer(from url: URL,
                         fileNamed: String,
                         completionHandler: @escaping (Result<UIImage, ServiceError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completionHandler(.success(image))

                    do {
                        try CacheService.shared.saveFile(named: fileNamed, folder: self.folderNamed, data: data)
                    } catch {
                        completionHandler(.failure(.decodeError))
                    }
                } else {
                    completionHandler(.failure(.unavailable))
                }
            }
        }.resume()
    }
}
