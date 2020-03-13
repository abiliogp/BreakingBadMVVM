//
//  ImageServiceTest.swift
//  BreakingBadMVVMTests
//
//  Created by Abilio Gambim Parada on 05/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import BreakingBadMVVM

class ImageServiceTest: XCTestCase {

    func testFetchImageWhenUrlOk() {
        let expectImg = XCTestExpectation(description: "expectImg")

        let imgUrl =
                """
                https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg
                """

        ImageService().fetchImage(from: imgUrl) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(let error):
                XCTAssertNil(error)
                XCTAssert(false)
            }
            expectImg.fulfill()
        }

        wait(for: [expectImg], timeout: 5.0)
    }

    func testErrorImageWhenUrlNOk() {
        let expectImg = XCTestExpectation(description: "expectImg")

        let imgUrl =
                """
                https://images.amcnetworks.com/amc/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg
                """

        ImageService().fetchImage(from: imgUrl) { result in
            switch result {
            case .success(let data):
                XCTAssertNil(data)
                XCTAssert(false)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectImg.fulfill()
        }

        wait(for: [expectImg], timeout: 5.0)
    }

    func testFetchImageIsCached() {
        let expectImg = XCTestExpectation(description: "expectImg")

        let imgUrl =
                """
                https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg
                """

        ImageService().fetchImage(from: imgUrl) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(let error):
                XCTAssertNil(error)
                XCTAssert(false)
            }
            expectImg.fulfill()
        }

        ImageService().fetchImage(from: imgUrl) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(let error):
                XCTAssertNil(error)
                XCTAssert(false)
            }
            expectImg.fulfill()
        }

        wait(for: [expectImg], timeout: 5.0)
    }

}
