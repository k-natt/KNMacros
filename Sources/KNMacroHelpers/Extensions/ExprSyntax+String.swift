//
//  ExprSyntax+String.swift
//
//
//  Created by Kevin on 7/6/23.
//

import Foundation
import SwiftSyntax


extension ExprSyntax {
    public func asStringLiteral() throws -> String {
        guard let strsyn = self.as(StringLiteralExprSyntax.self) else {
            throw Errors.wrongType(actual: StringLiteralExprSyntax.self, expected: nil).asError(from: self)
        }
        // We can get multiple segments, e.g. in a multi-line literal.
        return try strsyn.content()
    }
}

