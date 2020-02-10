//
//  CharactersViewModelTest.swift
//  BreakingBadMVVMTests
//
//  Created by Abilio Gambim Parada on 04/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import BreakingBadMVVM

class CharactersViewModelTest: XCTestCase {

    var viewModel: CharactersViewModel!
    var mockCharacterService: MockCharacterService!

    override func setUp() {
        super.setUp()
        mockCharacterService = MockCharacterService()
        viewModel = CharactersViewModel(service: mockCharacterService)
    }

    override func tearDown() {
        super.tearDown()
        mockCharacterService = nil
        viewModel = nil
    }

    func testShouldShowCharactersWhenLoaded() {
        //GIVEN
        let expectFetch = XCTestExpectation()

        var timesForLoading = 0
        var loading = false
        var charcs = [Character]()

        mockCharacterService.clear()

        viewModel.onLoading = { (load) in
            loading = load
            timesForLoading += 1
        }

        viewModel.onCharacters = { (characters) in
            charcs = characters
            expectFetch.fulfill()
        }

        //WHEN
        viewModel.setupController()

        //THEN
        wait(for: [expectFetch], timeout: 1.0)

        XCTAssert(loading == false)
        XCTAssert(charcs.isEmpty == false)
        XCTAssert(timesForLoading == 2)
    }

    func testShouldShowErrosWhenErro() {
        //GIVEN
        let expectError = XCTestExpectation()

        var timesForLoading = 0
        var loading = false
        var errorService: Error?

        mockCharacterService.clear()
        mockCharacterService.forceError = true

        viewModel.onLoading = { (load) in
            loading = load
            timesForLoading += 1
        }

        viewModel.onError = { (error) in
            errorService = error
            expectError.fulfill()
        }

        //WHEN
        viewModel.setupController()

        //THEN
        wait(for: [expectError], timeout: 1.0)

        XCTAssert(loading == false)
        XCTAssert(timesForLoading == 2)

        XCTAssert(errorService is ServiceError)
    }

}
