//
//  EnumCasesTests.swift
//
//
//  Created by Kevin on 7/8/23.
//

import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder
import KNMacroHelpers

final class EnumCasesTests: XCTestCase {
    func testEnum() {
        let enumDecl: any DeclGroupSyntax = ("""
        enum Foo {
            case bar
            case baz, quux
            func a() {}
            var b: Int { 1 }
        }
        """ as DeclSyntax).cast(EnumDeclSyntax.self)
        XCTAssertEqual(enumDecl.caseNamesIfEnum(), ["bar", "baz", "quux"])
    }
}
