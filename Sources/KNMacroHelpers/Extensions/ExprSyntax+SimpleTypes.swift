//
//  ExprSyntax+SimpleTypes.swift
//
//
//  Created by Kevin on 7/12/23.
//

import Foundation
import SwiftSyntax

 extension ArrayExprSyntax {
    func asSimpleType() -> SimpleType? {
        .array(elements.map { $0.expression.asSimpleType() })
    }
}

public extension BooleanLiteralExprSyntax {
    func asSimpleType() -> SimpleType? {
        .bool(booleanLiteral.text == "true")
    }
}

public extension DictionaryExprSyntax {
    func asSimpleType() -> SimpleType? {
        let elements: [(key: SimpleType?, value: SimpleType?)]
        switch content {
        case .colon: elements = []
        case .elements(let dels):
            elements = dels.map { element in
                (element.keyExpression.asSimpleType(), element.valueExpression.asSimpleType())
            }
        }
        return .dict(elements)
    }
}

extension FloatLiteralExprSyntax {
    func asSimpleType() -> SimpleType? {
        Double(digits.text).map(SimpleType.float)
    }
}

extension IdentifierExprSyntax {
    func asSimpleType() -> SimpleType? {
        guard declNameArguments == nil else {
            // Possibly a function name, idk. Not handling it in any case.
            return nil
        }
        return .identifier(identifier.text)
    }
}

extension IntegerLiteralExprSyntax {
    func asSimpleType() -> SimpleType? {
        Int(digits.text).map(SimpleType.int)
    }
}

extension MemberAccessExprSyntax {
    func asSimpleType() -> SimpleType? {
        guard declNameArguments == nil else {
            // Possibly a function name, idk. Not handling it in any case.
            return nil
        }
        return .access(base?.asSimpleType(), name.text)
    }
}

extension NilLiteralExprSyntax {
    func asSimpleType() -> SimpleType? { .nil }
}

extension StringLiteralExprSyntax {
    func asSimpleType() -> SimpleType? {
        (try? content()).map(SimpleType.string)
    }
}

extension TupleExprSyntax {
    func asSimpleType() -> SimpleType? {
        .tupleList(elements.collect())
    }
}

extension TupleExprElementListSyntax {
    func collect() -> TupleList {
        map { ($0.label?.text, $0.expression.asSimpleType()) }
    }
}

public extension ExprSyntaxProtocol {
    func asSimpleType() -> SimpleType? {
        if let a = self.as(ArrayExprSyntax.self) {
            return a.asSimpleType()
        }
        if let b = self.as(BooleanLiteralExprSyntax.self) {
            return b.asSimpleType()
        }
        if let d = self.as(DictionaryExprSyntax.self) {
            return d.asSimpleType()
        }
        if let f = self.as(FloatLiteralExprSyntax.self) {
            return f.asSimpleType()
        }
        if let id = self.as(IdentifierExprSyntax.self) {
            return id.asSimpleType()
        }
        if let int = self.as(IntegerLiteralExprSyntax.self) {
            return int.asSimpleType()
        }
        if let m = self.as(MemberAccessExprSyntax.self) {
            return m.asSimpleType()
        }
        if let n = self.as(NilLiteralExprSyntax.self) {
            return n.asSimpleType()
        }
        if let s = self.as(StringLiteralExprSyntax.self) {
            return s.asSimpleType()
        }
        if let t = self.as(TupleExprSyntax.self) {
            return t.asSimpleType()
        }
        // Maybe some day, not right now.
//        .node(OptionalChainingExprSyntax.self),
//        .node(RegexLiteralExprSyntax.self),

        return nil
    }
}
