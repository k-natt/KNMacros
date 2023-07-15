//
//  StringTests.swift
//
//
//  Created by Kevin on 7/15/23.
//

import Foundation
import KNMacroHelpers
import XCTest

class StringTests: XCTestCase {
    func test() {
        XCTAssertEqual("abcDEF".uppercaseFirstLetter(), "AbcDEF")
    }
}
