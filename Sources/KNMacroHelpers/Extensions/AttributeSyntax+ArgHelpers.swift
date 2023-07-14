//
//  AttributeSyntax+ArgHelpers.swift
//
//
//  Created by Kevin on 7/12/23.
//

import Foundation
import SwiftSyntax

public typealias TupleList = [(label: String?, value: SimpleType?)]
indirect public enum SimpleType {
    case access(SimpleType?, String)
    case array([SimpleType?])
    case dict([(key: SimpleType?, value: SimpleType?)]) // no/not yet.
    case bool(Bool)
    case float(Double)
    case identifier(String)
    case int(Int)
    case `nil`
    case string(String)
    // May be a literal tuple, could also be an argument list or similar.
    case tupleList(TupleList)
}

extension SimpleType: Equatable {
    public static func ==(lhs: SimpleType, rhs: SimpleType) -> Bool {
        switch (lhs, rhs) {
        case (.access(let t1, let s1), .access(let t2, let s2)):
            return t1 == t2 && s1 == s2
        case (.array(let l1), .array(let l2)):
            return l1.count == l2.count && zip(l1, l2).allSatisfy(==)
        case (.dict(let d1), .dict(let d2)):
            return d1.count == d2.count && zip(d1, d2).allSatisfy { l, r in
                l.key == r.key && l.value == r.value
            }
        case (.bool(let l), .bool(let r)):
            return l == r
        case (.float(let l), .float(let r)):
            return l == r
        case (.identifier(let l), .identifier(let r)):
            return l == r
        case (.int(let l), .int(let r)):
            return l == r
        case (.nil, .nil):
            return true
        case (.string(let l), .string(let r)):
            return l == r
        case (.tupleList(let t1), .tupleList(let t2)):
            return t1.count == t2.count && zip(t1, t2).allSatisfy {
                let ((l1, v1), (l2, v2)) = $0
                return l1 == l2 && v1 == v2
            }
        default:
            return false
        }
    }
}

public extension ArrayExprSyntax {
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

public extension AttributeSyntax {
    func args() throws -> TupleList {
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
