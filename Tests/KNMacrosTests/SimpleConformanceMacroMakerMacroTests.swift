//
//  SimpleConformanceMacroMakerMacroTests.swift
//  
//
//  Created by Kevin on 7/5/23.
//

import XCTest

import KNMacrosMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport

private let testMacros: [String: Macro.Type] = [
    "conformer": SimpleConformanceMacroMakerMacro.self,
]

final class SimpleConformanceMacroMakerMacroTests: XCTestCase {
    func testJustProto() {
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
                return []
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
    }

    func testWithDecls() {
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
                return [
                "var x: Int",
                "var y: String"]
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
    }
}
