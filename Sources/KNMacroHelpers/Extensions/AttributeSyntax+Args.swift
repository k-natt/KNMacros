//
//  AttributeSyntax+Args.swift
//
//
//  Created by Kevin on 7/14/23.
//

import Foundation
import SwiftSyntax

public extension AttributeSyntax {
    /// Willl throw an error if count is nonnull and does not match the actual list length.
    func args(expect count: Int? = nil) throws -> SimpleTupleList {
        guard let argument else { return [] }
        switch argument {
        case .argumentList(let list):
            let args = list.collect()
            if let count, args.count != count {
                throw Errors.wrongCount(noun: "argument", actual: args.count, expected: count).asError(from: argument)
            }
            return args

        // Fairly sure this can't happen for a macro but we can handle it so may as well.
        case .string(let expr):
            if let count, count != 1 {
                throw Errors.wrongCount(noun: "argument", actual: 1, expected: count).asError(from: argument)
            }
            return [(nil, .string(try expr.content()))]

        default:
            throw Errors.wrongType(actual: type(of: argument._syntaxNode), expected: nil).asError(from: argument)
        }
    }
}
