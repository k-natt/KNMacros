//
//  DummyMacroMakerMacro.swift
//
//
//  Created by Kevin on 7/5/23.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct DummyMacroMakerMacro {}

extension DummyMacroMakerMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        [
            """
            public static func expansion(
                of node: AttributeSyntax,
                providingAccessorsOf declaration: some DeclSyntaxProtocol,
                in context: some MacroExpansionContext
            ) throws -> [AccessorDeclSyntax] {[]}
            """,
            """
            public static func expansion(
                of node: some FreestandingMacroExpansionSyntax,
                in context: some MacroExpansionContext
            ) throws -> [CodeBlockItemSyntax] {[]}
            """,
            """
            public static func expansion(
                of node: AttributeSyntax,
                providingConformancesOf declaration: some DeclGroupSyntax,
                in context: some MacroExpansionContext
            ) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {[]}
            """,
            """
            public static func expansion(
                of node: some FreestandingMacroExpansionSyntax,
                in context: some MacroExpansionContext
            ) throws -> [DeclSyntax] {[]}
            """,
            """
            public static func expansion(
                of node: some FreestandingMacroExpansionSyntax,
                in context: some MacroExpansionContext
            ) throws -> ExprSyntax { "nil" }
            """, //!!!!!!!!!!!!!!!!! ^ body
            """
            public static func expansion(
                of node: AttributeSyntax,
                attachedTo declaration: some DeclGroupSyntax,
                providingAttributesFor member: some DeclSyntaxProtocol,
                in context: some MacroExpansionContext
            ) throws -> [AttributeSyntax] {[]}
            """,
            """
            public static func expansion(
                of node: AttributeSyntax,
                providingMembersOf declaration: some DeclGroupSyntax,
                in context: some MacroExpansionContext
            ) throws -> [DeclSyntax] {[]}
            """,
            """
            public static func expansion(
                of node: AttributeSyntax,
                providingPeersOf declaration: some DeclSyntaxProtocol,
                in context: some MacroExpansionContext
            ) throws -> [DeclSyntax] {[]}
            """
        ]
    }
}

extension DummyMacroMakerMacro: ConformanceMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingConformancesOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {
        [
            ("AccessorMacro", nil),
            ("CodeItemMacro", nil),
            ("ConformanceMacro", nil),
            ("DeclarationMacro", nil),
            ("ExpressionMacro", nil),
            ("MemberAttributeMacro", nil),
            ("MemberMacro", nil),
            ("PeerMacro", nil),
        ]
    }
}
