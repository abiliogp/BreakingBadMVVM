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
        
        let imgUrl = "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg"
        
        ImageService.shared.fetchImage(from: imgUrl) { result in
            switch (result){
            case .success(let data):
                XCTAssertNotNil(data)
                break
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
        
        let imgUrl = "https://images.amcnetworks.com/amc/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg"
        
        ImageService.shared.fetchImage(from: imgUrl) { result in
            switch (result){
            case .success(let data):
                XCTAssertNil(data)
                XCTAssert(false)
                break
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectImg.fulfill()
        }
        
        wait(for: [expectImg], timeout: 5.0)
    }
    
    func testFetchImageIsCached() {
        let expectImg = XCTestExpectation(description: "expectImg")
        
        let imgUrl = "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg"
        
        ImageService.shared.fetchImage(from: imgUrl) { result in
            switch (result){
            case .success(let data):
                XCTAssertNotNil(data)
                break
            case .failure(let error):
                XCTAssertNil(error)
                XCTAssert(false)
            }
            expectImg.fulfill()
        }
        
        ImageService.shared.fetchImage(from: imgUrl) { result in
            switch (result){
            case .success(let data):
                XCTAssertNotNil(data)
                break
            case .failure(let error):
                XCTAssertNil(error)
                XCTAssert(false)
            }
            expectImg.fulfill()
        }
        
        wait(for: [expectImg], timeout: 5.0)
    }
    
    func testExtractFileName() {
        let input = "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg"
        
        let output = ImageService.shared.extractFileName(input: input)
        
        XCTAssertEqual(output, "cast_bb_700x1000_walter-white-lg.jpg")
    }
    
    func testExtractFileNameFromMiddle() {
        let input = "https://vignette.wikia.nocookie.net/breakingbad/images/1/16/Saul_Goodman.jpg/revision/latest?cb=20120704065846"
        
        let output = ImageService.shared.extractFileName(input: input)
        
        XCTAssertEqual(output, "Saul_Goodman.jpg")
    }
    
    func testExtractFileNameFromPng() {
        let input = "https://vignette.wikia.nocookie.net/breakingbad/images/9/95/Todd_brba5b.png/revision/latest?cb=20130717134303"
        
        let output = ImageService.shared.extractFileName(input: input)
        
        XCTAssertEqual(output, "Todd_brba5b.png")
    }

}
