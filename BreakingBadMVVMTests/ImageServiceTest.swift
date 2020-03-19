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
        let imgUrl =
        """
        https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/\
        cast_bb_700x1000_walter-white-lg.jpg
        """

        let (imgData, serviceError) = fetchImage(from: imgUrl)

        XCTAssertNotNil(imgData)
        XCTAssertNil(serviceError)
    }

    func testErrorImageWhenUrlNOk() {
        let imgUrl =
        """
        https://images.amcnetworks.com/amc/wp-content/uploads/2015/04/\
        cast_bb_700x1000_walter-white-lg
        """

        let (imgData, serviceError) = fetchImage(from: imgUrl)

        XCTAssertNil(imgData)
        XCTAssertNotNil(serviceError)
        XCTAssertEqual(serviceError, ServiceError.decodeError)
    }

    func testFetchImageIsCached() throws {

        let imgUrl =
        """
        https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/\
        cast_bb_700x1000_walter-white-lg.jpg
        """

        let (imgData, serviceError) = fetchImage(from: imgUrl)

        let (imgDataCached, serviceErrorCached) = fetchImage(from: imgUrl)

        XCTAssertNotNil(imgData)
        XCTAssertNil(serviceError)

        XCTAssertNotNil(imgDataCached)
        XCTAssertNil(serviceErrorCached)
    }

}

extension ImageServiceTest {
    private func fetchImage(from: String) -> (UIImage?, ServiceError?) {
        let expectImg = XCTestExpectation(description: "expectImg")

        var imgData: UIImage?
        var serviceError: ServiceError?

        ImageService().fetchImage(from: from) { result in
            switch result {
            case .success(let data):
                imgData = data
            case .failure(let error):
                serviceError = error
            }
            expectImg.fulfill()
        }

        wait(for: [expectImg], timeout: 5.0)

        return (imgData, serviceError)
    }
}
