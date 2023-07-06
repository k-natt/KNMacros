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

enum StringParserError: Error {
    case notAString
    case noInterpolationAllowed
}

//@conformer(
//  to: "ProtoName",
//  with: "var x = 1",
//    "var y = 2"
//)
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
        var exprs: [ExprSyntax] = []
        while let next = iter.next() {
            exprs.append(next.expression)
        }
        let decls = ArrayExprSyntax(elements: .init(itemsBuilder: {
            for e in exprs {
                ArrayElementSyntax(expression: e)
            }
        }))
        return [
            """
            public static func expansion(
                of node: AttributeSyntax,
                providingMembersOf declaration: some DeclGroupSyntax,
                in context: some MacroExpansionContext
            ) throws -> [DeclSyntax] {
                return \(decls)
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
