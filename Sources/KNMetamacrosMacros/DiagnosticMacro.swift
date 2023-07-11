//
//  DiagnosticMacro.swift
//
//
//  Created by Kevin on 7/8/23.
//

import Foundation
import SwiftDiagnostics
import SwiftSyntaxBuilder
import SwiftSyntax
import SwiftSyntaxMacros
import KNMacroHelpers

enum DME: String {
    case notAnEnum = "Must be attached to an enum"
    case notAString = "Must be string RawRepresentable"

    var diagnosticID: MessageID {
        MessageID(domain: "DME", id: "\(1)")
    }
    var message: String { rawValue }
    var severity: DiagnosticSeverity { .error }

    func asDiagnosticError(at node: SyntaxProtocol) -> DiagnosticsError {
        DiagnosticsError(diagnostics: [Diagnostic(node: Syntax(node), message: self)])
    }
}
extension DME: DiagnosticMessage {}

public enum DiagnosticMacro {}

extension DiagnosticMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let cases = declaration.caseNamesIfEnum() else {
            throw DME.notAnEnum.asDiagnosticError(at: declaration)
        }
        guard declaration.inheritsFromSimple("String") else {
            throw DME.notAString.asDiagnosticError(at: declaration)
        }

        let idSwitch = """
        switch self {
        \(cases.enumerated().map({"""
            case .\($0.element):
                id = \($0.offset)
        """}).joined(separator: "\n"))
            }
        """ // ^ that ending brace has to be indented here or it won't be indented in the final source.

        return accessorize(to: declaration, [
            """
            var diagnosticID: MessageID {
                let id: Int
                \(raw: idSwitch)
                return MessageID(domain: "DME", id: "\\(id)")
            }
            """,
            "var message: String { rawValue }",
            "var severity: DiagnosticSeverity { .error }",
            """
            func asDiagnosticError(at node: SyntaxProtocol) -> DiagnosticsError {
                DiagnosticsError(diagnostics: [Diagnostic(node: Syntax(node), message: self)])
            }
            """,
        ])
    }
}

extension DiagnosticMacro: ConformanceMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingConformancesOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {
        [("DiagnosticMessage", nil)]
    }
}
