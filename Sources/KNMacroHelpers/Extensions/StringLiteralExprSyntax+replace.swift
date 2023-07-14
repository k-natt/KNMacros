//
//  StringLiteralExprSyntax+replace.swift
//  
//
//  Created by Kevin on 7/5/23.
//

import Foundation
import SwiftSyntaxBuilder
import SwiftSyntax
import SwiftDiagnostics

extension StringLiteralSegmentsSyntax.Element {
    public func content() throws -> String {
        switch self {
        case .stringSegment(let syntax):
            return syntax.content.text
        case .expressionSegment(let syntax):
            throw Errors.noStringInterpolation.asError(from: syntax)
        }
    }
}
extension StringLiteralExprSyntax {
    public func content() throws -> String {
        try segments.map { try $0.content() } .joined()
    }

    mutating public func replace(text: String, with expr: ExprSyntax) {
        segments = StringLiteralSegmentsSyntax(segments.flatMap { segment -> [StringLiteralSegmentsSyntax.Element] in
            switch segment {
            case .expressionSegment: return [segment]
            case .stringSegment(let syn):
                var strs: [StringLiteralSegmentsSyntax.Element] = []
                strs = syn.content.text.components(separatedBy: text).map {
                    .stringSegment(StringSegmentSyntax(content: .stringSegment(String($0))))
                }

                for idx in (1..<strs.count).reversed() {
                    strs.insert(.expressionSegment(ExpressionSegmentSyntax(expressionsBuilder: {
                        TupleExprElementSyntax(expression: expr)
                    })), at: idx)
                }

                return strs
            }
        })

    }
}
