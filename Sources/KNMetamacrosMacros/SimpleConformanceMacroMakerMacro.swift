//
//  SimpleConformanceMacroMakerMacro.swift
//
//
//  Created by Kevin on 7/5/23.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum SCMMMError: Error {
    case noargs
    case emptyargs
}

public struct SimpleConformanceMacroMakerMacro {}

extension SimpleConformanceMacroMakerMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard case .argumentList(let list) = node.argument else {
            throw SCMMMError.noargs
        }
        var iter = list.makeIterator()
        guard let first = iter.next() else {
            throw SCMMMError.emptyargs
        }
        let proto = first.expression
        // Need to collect these all from the iterator because we can't do `while` inside a builder.
        var allDecls = [String]()
        while let next = iter.next() {
            allDecls.append(next.expression.trimmedDescription)
        }
        return [
            """
            public static func expansion(
                of node: AttributeSyntax,
                providingMembersOf declaration: some DeclGroupSyntax,
                in context: some MacroExpansionContext
            ) throws -> [DeclSyntax] {
                [
                    \(raw: allDecls.joined(separator: ",\n        "))
                ]
            }
            """,
            """
            public static func expansion(
                of node: AttributeSyntax,
                providingConformancesOf declaration: some DeclGroupSyntax,
                in context: some MacroExpansionContext
            ) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {
                [
                    (\(proto), nil),
                ]
            }
            """,
        ]
    }
}

extension SimpleConformanceMacroMakerMacro: ConformanceMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingConformancesOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {
        [
            ("MemberMacro", nil),
            ("ConformanceMacro", nil)
        ]
    }
}
