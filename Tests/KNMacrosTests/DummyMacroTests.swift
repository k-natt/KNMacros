//
//  DummyMacroTests.swift
//  
//
//  Created by Kevin on 7/5/23.
//

import XCTest

import KNMacrosMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport

private let testMacros: [String: Macro.Type] = [
    "dummy": DummyMacroMakerMacro.self,
]

final class DummyMacroTests: XCTestCase {
    func test() {
        assertMacroExpansion("""
        @dummy public struct DummyMacro {}
        """, expandedSource: """
        public struct DummyMacro {
            public static func expansion(
                of node: AttributeSyntax,
                providingAccessorsOf declaration: some DeclSyntaxProtocol,
                in context: some MacroExpansionContext
            ) throws -> [AccessorDeclSyntax] {
                []
            }
            public static func expansion(
                of node: some FreestandingMacroExpansionSyntax,
                in context: some MacroExpansionContext
            ) throws -> [CodeBlockItemSyntax] {
                []
            }
            public static func expansion(
                of node: AttributeSyntax,
                providingConformancesOf declaration: some DeclGroupSyntax,
                in context: some MacroExpansionContext
            ) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {
                []
            }
            public static func expansion(
                of node: some FreestandingMacroExpansionSyntax,
                in context: some MacroExpansionContext
            ) throws -> [DeclSyntax] {
                []
            }
            public static func expansion(
                of node: some FreestandingMacroExpansionSyntax,
                in context: some MacroExpansionContext
            ) throws -> ExprSyntax {
                "nil"
            }
            public static func expansion(
                of node: AttributeSyntax,
                attachedTo declaration: some DeclGroupSyntax,
                providingAttributesFor member: some DeclSyntaxProtocol,
                in context: some MacroExpansionContext
            ) throws -> [AttributeSyntax] {
                []
            }
            public static func expansion(
                of node: AttributeSyntax,
                providingMembersOf declaration: some DeclGroupSyntax,
                in context: some MacroExpansionContext
            ) throws -> [DeclSyntax] {
                []
            }
            public static func expansion(
                of node: AttributeSyntax,
                providingPeersOf declaration: some DeclSyntaxProtocol,
                in context: some MacroExpansionContext
            ) throws -> [DeclSyntax] {
                []
            }
        }
        extension DummyMacro: AccessorMacro {
        }
        extension DummyMacro: CodeItemMacro {
        }
        extension DummyMacro: ConformanceMacro {
        }
        extension DummyMacro: DeclarationMacro {
        }
        extension DummyMacro: ExpressionMacro {
        }
        extension DummyMacro: MemberAttributeMacro {
        }
        extension DummyMacro: MemberMacro {
        }
        extension DummyMacro: PeerMacro {
        }
        """, macros: testMacros)
    }
}
