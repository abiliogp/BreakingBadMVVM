//
//  CharacterServiceTests.swift
//  BreakingBadMVVMTests
//
//  Created by Abilio Gambim Parada on 04/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import BreakingBadMVVM

class CharacterServiceTests: XCTestCase{
    
    func testShouldReturnDataWhenFetch() {
        let expectFetch = XCTestExpectation()
        
        Service.shared.fetchCharacters(completionHandler: { result in
            switch(result){
            case .success(let characters):
                XCTAssertFalse(characters.isEmpty)
                XCTAssertEqual(characters.count, 63)
                break
            case .failure(let error):
                XCTAssertNotNil(error)
                break
            }
            expectFetch.fulfill()
        })
        
        wait(for: [expectFetch], timeout: 5.0)
    }

}
