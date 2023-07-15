//
//  EnumAccessorMacroTests.swift
//
//
//  Created by Kevin on 7/14/23.
//

import Foundation
import KNMacrosMacros
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

private let testMacros: [String: Macro.Type] = [
    "accessors": EnumAccessorMacro.self,
]

final class EnumAccessorMacroTests: XCTestCase {
    func test() {
        assertMacroExpansion("""
        @accessors
        indirect public enum SimpleType {
            case access(SimpleType?, String)
            case array([SimpleType?])
            case dict([(key: SimpleType?, value: SimpleType?)])
            case bool(Bool)
            case float(Double)
            case identifier(String)
            case int(Int)
            case `nil`
            case string(String)
            case tupleList(SimpleTupleList)
        }
        """, expandedSource: """
        indirect public enum SimpleType {
            case access(SimpleType?, String)
            case array([SimpleType?])
            case dict([(key: SimpleType?, value: SimpleType?)])
            case bool(Bool)
            case float(Double)
            case identifier(String)
            case int(Int)
            case `nil`
            case string(String)
            case tupleList(SimpleTupleList)
            public var asAccess: (SimpleType?, String)? {
                 guard case .access(let value0, let value1) = self else {
                     return nil
                 }
                 return (value0, value1)
             }
            public var asArray: [SimpleType?]? {
                 guard case .array(let value) = self else {
                     return nil
                 }
                 return value
             }
            public var asDict: [(key: SimpleType?, value: SimpleType?)]? {
                 guard case .dict(let value) = self else {
                     return nil
                 }
                 return value
             }
            public var asBool: Bool? {
                 guard case .bool(let value) = self else {
                     return nil
                 }
                 return value
             }
            public var asFloat: Double? {
                 guard case .float(let value) = self else {
                     return nil
                 }
                 return value
             }
            public var asIdentifier: String? {
                 guard case .identifier(let value) = self else {
                     return nil
                 }
                 return value
             }
            public var asInt: Int? {
                 guard case .int(let value) = self else {
                     return nil
                 }
                 return value
             }
            public var isNil: Bool {
                 guard case .nil = self else {
                     return false
                 }
                 return true
             }
            public var asString: String? {
                 guard case .string(let value) = self else {
                     return nil
                 }
                 return value
             }
            public var asTupleList: SimpleTupleList? {
                 guard case .tupleList(let value) = self else {
                     return nil
                 }
                 return value
             }
        }
        """, macros: testMacros)
    }
}

