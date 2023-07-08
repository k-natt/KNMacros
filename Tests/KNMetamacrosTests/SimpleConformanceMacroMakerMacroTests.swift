//
//  SimpleConformanceMacroMakerMacroTests.swift
//  
//
//  Created by Kevin on 7/5/23.
//

import XCTest

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(KNMetamacrosMacros)
import KNMetamacrosMacros

private let testMacros: [String: Macro.Type] = [
    "conformer": SimpleConformanceMacroMakerMacro.self,
]
#endif

final class SimpleConformanceMacroMakerMacroTests: XCTestCase {
    func testJustProto() throws {
#if canImport(KNMetamacrosMacros)
        assertMacroExpansion("""
        @conformer(to: "Something")
        public struct SomethingConformerMacro {}
        """, expandedSource: """
        public struct SomethingConformerMacro {
            public static func expansion(
                of node: AttributeSyntax,
                providingMembersOf declaration: some DeclGroupSyntax,
                in context: some MacroExpansionContext
            ) throws -> [DeclSyntax] {
                [

                ]
            }
            public static func expansion(
                of node: AttributeSyntax,
                providingConformancesOf declaration: some DeclGroupSyntax,
                in context: some MacroExpansionContext
            ) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {
                [
                    ("Something", nil),
                ]
            }
        }
        extension SomethingConformerMacro: MemberMacro {
        }
        extension SomethingConformerMacro: ConformanceMacro {
        }
        """, macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testWithDecls() throws {
#if canImport(KNMetamacrosMacros)
        assertMacroExpansion("""
        @conformer(to: "Something", with:
            "var x: Int",
            "var y: String"
        )
        public struct SomethingConformerMacro {}
        """, expandedSource: """
        public struct SomethingConformerMacro {
            public static func expansion(
                of node: AttributeSyntax,
                providingMembersOf declaration: some DeclGroupSyntax,
                in context: some MacroExpansionContext
            ) throws -> [DeclSyntax] {
                [
                    "var x: Int",
                    "var y: String"
                ]
            }
            public static func expansion(
                of node: AttributeSyntax,
                providingConformancesOf declaration: some DeclGroupSyntax,
                in context: some MacroExpansionContext
            ) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {
                [
                    ("Something", nil),
                ]
            }
        }
        extension SomethingConformerMacro: MemberMacro {
        }
        extension SomethingConformerMacro: ConformanceMacro {
        }
        """, macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testWithCombinedDecls() throws {
#if canImport(KNMetamacrosMacros)
        assertMacroExpansion("""
        @conformer(to: "Something", with: \"""
            var x = 1
            public var y: String
            open func foo() -> Bar? {
                nil
            }
        \""")
        public struct SomethingConformerMacro {}
        """, expandedSource: """
        public struct SomethingConformerMacro {
            public static func expansion(
                of node: AttributeSyntax,
                providingMembersOf declaration: some DeclGroupSyntax,
                in context: some MacroExpansionContext
            ) throws -> [DeclSyntax] {
                [
                    \"""
                        var x = 1
                        public var y: String
                        open func foo() -> Bar? {
                            nil
                        }
                    \"""
                ]
            }
            public static func expansion(
                of node: AttributeSyntax,
                providingConformancesOf declaration: some DeclGroupSyntax,
                in context: some MacroExpansionContext
            ) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {
                [
                    ("Something", nil),
                ]
            }
        }
        extension SomethingConformerMacro: MemberMacro {
        }
        extension SomethingConformerMacro: ConformanceMacro {
        }
        """, macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
