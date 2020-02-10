//
//  BreakingBadMVVMTestSuite.swift
//  BreakingBadMVVMTests
//
//  Created by Abilio Gambim Parada on 04/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import BreakingBadMVVM

class BreakingBadMVVMTestSuite: XCTestCase {

    override class var defaultTestSuite: XCTestSuite {
        let suite = XCTestSuite(forTestCaseClass: BreakingBadMVVMTestSuite.self)
        XCTestSuite(forTestCaseClass: CharacterServiceTests.self).tests.forEach { suite.addTest($0)}
        XCTestSuite(forTestCaseClass: CharactersViewModelTest.self).tests.forEach { suite.addTest($0)}
        XCTestSuite(forTestCaseClass: ImageServiceTest.self).tests.forEach { suite.addTest($0)}
        XCTestSuite(forTestCaseClass: CacheServiceTest.self).tests.forEach { suite.addTest($0)}
        return suite
    }

    func testingStarts() {
        XCTAssert(true)
    }
}
