//
//  AttributeSyntax+Args.swift
//
//
//  Created by Kevin on 7/14/23.
//

import Foundation
import SwiftSyntax

public extension AttributeSyntax {
    func args() throws -> SimpleTupleList {
        guard let argument else { return [] }
        switch argument {
        case .argumentList(let list):
            return list.collect()

        // Fairly sure this can't happen for a macro but we can handle it so may as well.
        case .string(let expr):
            return [(nil, .string(try expr.content()))]

        default:
            throw Errors.wrongType(actual: type(of: argument._syntaxNode), expected: nil).asError(from: argument)
        }
    }
}
