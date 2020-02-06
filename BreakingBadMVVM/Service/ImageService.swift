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
    
    private let folderNamed = "img"
    
    private static var imgDic: [String:Data] = [:]
    
    private init(){}
    
}

extension ImageService: ImageServiceProtocol{
    
    func fetchImage(from url: String, completionHandler: @escaping (Result<UIImage, ServiceError>) -> Void) {
        guard let imgUrl = URL(string: url) else { return }
        
        let fileNamed = CacheService.shared.extractFileName(input: imgUrl.path)
        
        if CacheService.shared.hasFile(named: fileNamed, folder: folderNamed) {
            do{
                try CacheService.shared.loadFile(named: fileNamed, folder: folderNamed) { (data) in
                    if let image = UIImage(data: data){
                        completionHandler(.success(image))
                    }
                }
            } catch{
                fetchFromServer(from: imgUrl, fileNamed: fileNamed) { (result) in
                    completionHandler(result)
                }
            }
        } else{
            fetchFromServer(from: imgUrl, fileNamed: fileNamed) { (result) in
                completionHandler(result)
            }
        }
    }
    
    func fetchFromServer(from url: URL, fileNamed: String, completionHandler: @escaping (Result<UIImage, ServiceError>) -> Void){
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data){
                    completionHandler(.success(image))
                    
                    try! CacheService.shared.saveFile(named: fileNamed, folder: self.folderNamed, data: data)
                } else{
                    completionHandler(.failure(.unavailable))
                }
            }
        }.resume()
    }
}
