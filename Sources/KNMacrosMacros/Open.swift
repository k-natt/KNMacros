//
//  Open.swift
//  
//
//  Created by Kevin on 6/24/23.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

// Doesn't actually do anything itself, just a marker for OpenMacro.
public struct RawValueMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        []
    }
}

enum OpenError: Error, CustomStringConvertible {
    case notAnEnum

    var description: String {
        switch self {
        case .notAnEnum:
            return "Must be attached to an enum."
        }
    }
}

extension EnumCaseElementListSyntax.Element {
    var rawStringValue: String {
        if let explicitValue = rawValue?.value {
            return "\(explicitValue.trimmed)"
        }
        return "\"\(identifier.trimmed)\""
    }
}

public struct OpenMacro {}

extension OpenMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let decl = declaration.as(EnumDeclSyntax.self) else {
            throw OpenError.notAnEnum
        }
        let members = decl.memberBlock.members
        let rawType = "String"
        let caseDecls = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let elements = caseDecls.flatMap { $0.elements }

        let nonnullableInitializer = try InitializerDeclSyntax("init(_ rawValue: \(raw: rawType))") {
            try SwitchExprSyntax("switch rawValue") {
                for element in elements {
                    SwitchCaseSyntax(
                        """
                        case \(raw: element.rawStringValue):
                            self = .\(element.identifier)
                        """
                    )
                }
                SwitchCaseSyntax("default: self = .unknown(rawValue)")
            }
        }

        let rawValueDecl = try VariableDeclSyntax("var rawValue: \(raw: rawType)") {
            try CodeBlockItemListSyntax {
                try SwitchExprSyntax("switch self") {
                    for element in elements {
                        SwitchCaseSyntax(
                            """

                            case .\(element.identifier.trimmed):
                                return \(raw: element.rawStringValue)
                            """
                        )
                    }
                    SwitchCaseSyntax("\ncase .unknown(let rawValue): return rawValue")
                }
            }
        }

        return [
            "case unknown(\(raw: rawType))",
            "init?(rawValue: \(raw: rawType)) { self.init(rawValue) }",
            DeclSyntax(nonnullableInitializer),
            DeclSyntax(rawValueDecl),
        ]
    }
}

extension OpenMacro: ConformanceMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingConformancesOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {
        return [("RawRepresentable", nil)]
    }
}
