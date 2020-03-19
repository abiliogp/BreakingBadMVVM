//
//  CacheService.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 06/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

struct CacheService {

    private var fileManager: FileManager

    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    func createFolderIfNeed(folder: String) throws -> URL {
        let documentDirURL = try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)

        let folderURL = documentDirURL.appendingPathComponent(folder)

        if !fileManager.fileExists(atPath: folderURL.path) {
            try fileManager.createDirectory(
                atPath: folderURL.path,
                withIntermediateDirectories: true,
                attributes: nil)
            return folderURL
        } else {
            return folderURL
        }
    }

    func hasFile(named: String, folder: String) throws -> Bool {
        var folderURL = try createFolderIfNeed(folder: folder)
        folderURL.appendPathComponent(named)
        return fileManager.fileExists(atPath: folderURL.path)
    }

    func saveFile(named: String, folder: String, data: Data) throws {
        var folderURL = try createFolderIfNeed(folder: folder)
        folderURL.appendPathComponent(named)

        try data.write(to: folderURL, options: .atomic)
    }

    func loadFile(named: String, folder: String, completionHandler: @escaping ((Data) -> Void)) throws {
        var folderURL = try createFolderIfNeed(folder: folder)
        folderURL.appendPathComponent(named)

        let imgData = try Data(contentsOf: folderURL)
        completionHandler(imgData)
    }

    func remove(folder: String) throws {
        let documentDirURL = try fileManager.url(
                                                for: .documentDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: false)
        let folderURL = documentDirURL.appendingPathComponent(folder)
        if fileManager.fileExists(atPath: folderURL.path) {
            try fileManager.removeItem(atPath: folderURL.path)
        }
    }

    func extractFileName(input: String) -> String {
        return String(input.hash)
    }
}
