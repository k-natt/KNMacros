//
//  SimpleTypeHelpers.swift
//
//
//  Created by Kevin on 7/13/23.
//

import Foundation
import KNMacroHelpers
import SwiftSyntax
import XCTest

final class SimpleTypeHelpersTests: XCTestCase {
    func testArray() {
        let x = "[]" as ExprSyntax
        XCTAssertEqual(x.asSimpleType(), .array([]))
        let y = "[a, b]" as ExprSyntax
        XCTAssertEqual(y.asSimpleType(), .array([.identifier("a"), .identifier("b")]))
    }

    func testBool() {
        let x = "true" as ExprSyntax
        XCTAssertEqual(x.asSimpleType(), .bool(true))
        let y = "false" as ExprSyntax
        XCTAssertEqual(y.asSimpleType(), .bool(false))
    }

    func testDict() {
        let x = "[:]" as ExprSyntax
        XCTAssertEqual(x.asSimpleType(), .dict([]))
        let y = "[a: b]" as ExprSyntax
        XCTAssertEqual(y.asSimpleType(), .dict([(.identifier("a"), .identifier("b"))]))
    }

    func testFloat() {
        let x = "8675309e-3" as ExprSyntax
        XCTAssertEqual(x.asSimpleType(), .float(8675309e-3))
    }

    func testId() {
        let x = "a" as ExprSyntax
        XCTAssertEqual(x.asSimpleType(), .identifier("a"))
    }

    func testInt() {
        let x = "8675309" as ExprSyntax
        XCTAssertEqual(x.asSimpleType(), .int(8675309))
    }

    func testAccess() {
        let x = "MyEnum.value" as ExprSyntax
        XCTAssertEqual(x.asSimpleType(), .access(.identifier("MyEnum"), "value"))
        let y = ".value" as ExprSyntax
        XCTAssertEqual(y.asSimpleType(), .access(nil, "value"))
        let z = "A.b.c" as ExprSyntax
        XCTAssertEqual(z.asSimpleType(), .access(.access(.identifier("A"), "b"), "c"))
    }

    func testNil() {
        let x = """
        nil
        """ as ExprSyntax
        XCTAssertEqual(x.asSimpleType(), .nil)
    }

    func testString() {
        let x = """
        ""
        """ as ExprSyntax
        XCTAssertEqual(x.asSimpleType(), .string(""))
        let y = #""blah""# as ExprSyntax
        XCTAssertEqual(y.asSimpleType(), .string("blah"))
        let z = """
        #"ayo"#
        """ as ExprSyntax
        XCTAssertEqual(z.asSimpleType(), .string("ayo"))
    }

    func testTuple() {
        let x = """
        (a, lab: "b")
        """ as ExprSyntax
        XCTAssertEqual(x.asSimpleType(), .tupleList([
            (nil, .identifier("a")),
            ("lab", .string("b")),
        ]))
        let y = "()" as ExprSyntax
        XCTAssertEqual(y.asSimpleType(), .tupleList([]))
    }
}
