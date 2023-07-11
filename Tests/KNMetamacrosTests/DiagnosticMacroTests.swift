//
//  DiagnosticMacroTests.swift
//
//
//  Created by Kevin on 7/8/23.
//

import XCTest

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(KNMetamacrosMacros)
import KNMetamacrosMacros

private let testMacros: [String: Macro.Type] = [
    "diagnostic": DiagnosticMacro.self,
]

final class DiagnosticMacroTests: XCTestCase {
    func testNoAccess() {
        assertMacroExpansion("""
        @diagnostic
        enum FooError: String {
            case oops = "What did you do???"
            case darn = "Not again!"
        }
        """, expandedSource: """
        enum FooError: String {
            case oops = "What did you do???"
            case darn = "Not again!"
            var diagnosticID: MessageID {
                let id: Int
                switch self {
                case .oops:
                    id = 0
                case .darn:
                    id = 1
                }
                return MessageID(domain: "DME", id: "\\(id)")
            }
            var message: String {
                rawValue
            }
            var severity: DiagnosticSeverity {
                .error
            }
            func asDiagnosticError(at node: SyntaxProtocol) -> DiagnosticsError {
                DiagnosticsError(diagnostics: [Diagnostic(node: Syntax(node), message: self)])
            }
        }
        extension FooError: DiagnosticMessage {
        }
        """, macros: testMacros)
    }

    func testPublic() {
        assertMacroExpansion("""
        @diagnostic
        public enum FooError: String {
            case oops = "What did you do???"
            case darn = "Not again!"
        }
        """, expandedSource: """
        public enum FooError: String {
            case oops = "What did you do???"
            case darn = "Not again!"
            public var diagnosticID: MessageID {
                 let id: Int
                 switch self {
                 case .oops:
                     id = 0
                 case .darn:
                     id = 1
                 }
                 return MessageID(domain: "DME", id: "\\(id)")
             }
            public var message: String {
                rawValue
            }
            public var severity: DiagnosticSeverity {
                .error
            }
            public func asDiagnosticError(at node: SyntaxProtocol) -> DiagnosticsError {
                 DiagnosticsError(diagnostics: [Diagnostic(node: Syntax(node), message: self)])
             }
        }
        extension FooError: DiagnosticMessage {
        }
        """, macros: testMacros)
    }
}
#endif
