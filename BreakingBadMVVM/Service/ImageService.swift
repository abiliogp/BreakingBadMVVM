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
    
    private static var imgDic: [String:Data] = [:]
    
    private init(){}
    
}

extension ImageService: ImageServiceProtocol{
    
    func fetchImage(from url: String, completionHandler: @escaping (Result<UIImage, ServiceError>) -> Void) {
        guard let imgUrl = URL(string: url) else { return }
        
        let fileName = extractFileName(input: imgUrl.path)
        if checkIfExistImage(name: fileName) {
            loadImage(name: fileName) { (data) in
                if let image = UIImage(data: data){
                    completionHandler(.success(image))
                }
            }
        } else{
            URLSession.shared.dataTask(with: imgUrl) { (data, response, error) in
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data){
                        self.saveImage(data: data, name: fileName)

                        completionHandler(.success(image))
                    } else{
                        completionHandler(.failure(.unavailable))
                    }
                }
                
            }.resume()
        }
        

    }
    
    private func createFolder() -> URL{
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let folderURL = documentDirURL.appendingPathComponent("img")
        
        if !FileManager.default.fileExists(atPath: folderURL.path){
            try! FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
            return folderURL
        } else{
            return folderURL
        }
    }
    
    private func checkIfExistImage(name: String) -> Bool{
        var folderURL = createFolder()
        folderURL.appendPathComponent(name)
        return FileManager.default.fileExists(atPath: folderURL.path)
    }
    
    private func loadImage(name: String, completionHandler: @escaping ((Data) -> Void)){
        if let data = ImageService.imgDic[name]{
            completionHandler(data)
            return
        }
        
        var folderURL = createFolder()
        folderURL.appendPathComponent(name)
        do{
            let imgData = try Data(contentsOf: folderURL)
            completionHandler(imgData)
        } catch{
            
        }

    }
    
    private func saveImage(data: Data, name: String){
        var folderURL = createFolder()
        print(folderURL.path)
        print(try! FileManager.default.contentsOfDirectory(atPath: folderURL.path))
        folderURL.appendPathComponent(name)

        ImageService.imgDic[name] = data
        
        do{
            
            try data.write(to: folderURL, options: .atomic)
            
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func extractFileName(input: String) -> String{
        let components = input.components(separatedBy: "/")
        let output = components.filter { (str) -> Bool in
            return str.contains("jpg") || str.contains("png") || str.contains("jpeg") || str.contains("JPG")
        }.first
        return output ?? input
    }
}
