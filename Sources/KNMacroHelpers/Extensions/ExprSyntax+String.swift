//
//  ExprSyntax+String.swift
//
//
//  Created by Kevin on 7/6/23.
//

import Foundation
import SwiftSyntax

enum StringParserError: Error {
    case notAString
    case noInterpolationAllowed
}

extension ExprSyntax {
    public func asStringLiteral() throws -> String {
        guard let strsyn = self.as(StringLiteralExprSyntax.self) else {
            throw StringParserError.notAString
        }
        // We can get multiple segments, e.g. in a multi-line literal.
        return try strsyn.segments.map { segment -> String in
            switch segment {
            case .expressionSegment:
                throw StringParserError.noInterpolationAllowed
            case .stringSegment(let sss):
                return sss.content.text
            }
        }.joined()
    }
}

