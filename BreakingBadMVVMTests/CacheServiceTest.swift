//
//  CacheServiceTest.swift
//  BreakingBadMVVMTests
//
//  Created by Abilio Gambim Parada on 06/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import BreakingBadMVVM

class CacheServiceTest: XCTestCase {

    let folderName = "testImg"
    let cacheService = CacheService()

    func testShouldCreateFolderIfNeed() throws {
        let url = try cacheService.createFolderIfNeed(folder: folderName)
        XCTAssertNotNil(url.path)
    }

    func testShouldCheckForFile() throws {
        let hasFile = try cacheService.hasFile(named: "", folder: folderName)
        XCTAssert(hasFile)
    }

    func testShouldSaveFile() throws {
        let file = "test"
        let data = Data()

        try cacheService.saveFile(named: file, folder: folderName, data: data)
        let hasFile = try cacheService.hasFile(named: file, folder: folderName)

        XCTAssert(hasFile)
    }

    func testShouldLoadFile() throws {
        let expect = XCTestExpectation()

        let file = "test"
        let data = file.data(using: .ascii)!
        var loadData: Data!

        try cacheService.saveFile(named: file, folder: folderName, data: data)

        let hasFile = try cacheService.hasFile(named: file, folder: folderName)

        try cacheService.loadFile(named: file, folder: folderName) { (lData) in
            loadData = lData
            expect.fulfill()
        }

        wait(for: [expect], timeout: 1.0)

        XCTAssert(hasFile)
        XCTAssertEqual(data, loadData)
    }

    func testExtractFileName() throws {
        let input =
        """
        https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/\
        cast_bb_700x1000_walter-white-lg.jpg
        """

        let output = cacheService.extractFileName(input: input)

        XCTAssertEqual(output, "-1162917412196231299")
    }

    func testExtractFileNameFromMiddle() throws {
        let input =
        """
        https://vignette.wikia.nocookie.net/breakingbad/images/1/16/Saul_Goodman.jpg\
        /revision/latest?cb=20120704065846
        """

        let output = cacheService.extractFileName(input: input)

        XCTAssertEqual(output, "-5745117354248179294")
    }

    func testExtractFileNameFromPng() throws {
        let input =
        """
        https://vignette.wikia.nocookie.net/breakingbad/images/9/95/Todd_brba5b.png\
        /revision/latest?cb=20130717134303
        """

        let output = cacheService.extractFileName(input: input)

        XCTAssertEqual(output, "132032068468539766")
    }

}
