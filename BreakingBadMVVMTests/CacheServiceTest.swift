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

    override class func tearDown() {
        do {
            let url = try CacheService.shared.createFolderIfNeed(folder: "testImg")

            try FileManager.default.removeItem(atPath: url.path)
        } catch {
            assertionFailure()
        }
    }

    func testShouldCreateFolderIfNeed() {
        do {
            let url = try CacheService.shared.createFolderIfNeed(folder: folderName)

            XCTAssertNotNil(url.path)
        } catch {
            assertionFailure()
        }
    }

    func testShouldCheckForFile() {
        do {
            let hasFile = try CacheService.shared.hasFile(named: "", folder: folderName)

            XCTAssert(hasFile)
        } catch {
            assertionFailure()
        }
    }

    func testShouldSaveFile() {
        let file = "test"
        let data = Data()

        do {
            try CacheService.shared.saveFile(named: file, folder: folderName, data: data)
            let hasFile = try CacheService.shared.hasFile(named: file, folder: folderName)

            XCTAssert(hasFile)
        } catch {
            assertionFailure()
        }
    }

    func testShouldLoadFile() {
        let expect = XCTestExpectation()

        let file = "test"
        let data = file.data(using: .ascii)!
        var loadData: Data!

        do {
            try CacheService.shared.saveFile(named: file, folder: folderName, data: data)

            let hasFile = try CacheService.shared.hasFile(named: file, folder: folderName)

            try CacheService.shared.loadFile(named: file, folder: folderName) { (lData) in
                loadData = lData
                expect.fulfill()
            }

            wait(for: [expect], timeout: 1.0)

            XCTAssert(hasFile)
            XCTAssertEqual(data, loadData)
        } catch {
            assertionFailure()
        }
    }

    func testExtractFileName() {
        let input =
                """
                https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/\
                cast_bb_700x1000_walter-white-lg.jpg
                """

        let output = CacheService.shared.extractFileName(input: input)

        XCTAssertEqual(output, "-1162917412196231299")
    }

    func testExtractFileNameFromMiddle() {
        let input =
                """
                https://vignette.wikia.nocookie.net/breakingbad/images/1/16/Saul_Goodman.jpg\
                /revision/latest?cb=20120704065846
                """

        let output = CacheService.shared.extractFileName(input: input)

        XCTAssertEqual(output, "-5745117354248179294")
    }

    func testExtractFileNameFromPng() {
        let input =
                """
                https://vignette.wikia.nocookie.net/breakingbad/images/9/95/Todd_brba5b.png\
                /revision/latest?cb=20130717134303
                """

        let output = CacheService.shared.extractFileName(input: input)

        XCTAssertEqual(output, "132032068468539766")
    }

}
