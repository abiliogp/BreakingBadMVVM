//
//  CharacterServiceTests.swift
//  BreakingBadMVVMTests
//
//  Created by Abilio Gambim Parada on 04/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import BreakingBadMVVM

class CharacterServiceTests: XCTestCase {

    func testShouldReturnDataWhenFetch() {
        let (charcs, serviceError) = fetchCharacters()

        XCTAssertNil(serviceError)

        XCTAssertNotNil(charcs)
        XCTAssertFalse(charcs!.isEmpty)

    }

    func testShouldReturnWhenCached() throws {

        try CacheService().remove(folder: Files.Folder.characters)

        let (charcs, serviceError) = fetchCharacters()
        let (charcsCached, serviceErrorCached) = fetchCharacters()

        XCTAssertNil(serviceError)

        XCTAssertNotNil(charcs)
        XCTAssertFalse(charcs!.isEmpty)

        XCTAssertNil(serviceErrorCached)

        XCTAssertNotNil(charcsCached)
        XCTAssertFalse(charcsCached!.isEmpty)
    }
}

extension CharacterServiceTests {
    private func fetchCharacters() -> ([Character]?, ServiceError?) {
        let expectFetch = XCTestExpectation(description: "expectFetch")

        var charData: [Character]?
        var serviceError: ServiceError?

        CharacterService().fetchCharacters(completionHandler: { result in
            switch result {
            case .success(let characters):
                charData = characters
            case .failure(let error):
                serviceError = error
            }
            expectFetch.fulfill()
        })

        wait(for: [expectFetch], timeout: 5.0)

        return (charData, serviceError)
    }
}
