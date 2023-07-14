//
//  DiagnosticMessage+AsError.swift
//
//
//  Created by Kevin on 7/12/23.
//

import Foundation
import SwiftDiagnostics
import SwiftSyntax

public extension DiagnosticMessage {
    func asError(from node: SyntaxProtocol) -> DiagnosticsError {
        DiagnosticsError(diagnostics: [Diagnostic(node: node._syntaxNode, message: self)])
    }
}
