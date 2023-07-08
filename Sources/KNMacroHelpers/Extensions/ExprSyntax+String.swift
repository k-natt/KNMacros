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
    func asStringLiteral() throws -> String {
        guard let strsyn = self.as(StringLiteralExprSyntax.self) else {
            throw StringParserError.notAString
        }
        // We get multiple segments in a multi-line literal, for instance.
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

