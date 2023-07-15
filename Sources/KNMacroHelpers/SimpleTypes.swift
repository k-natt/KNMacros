//
//  SimpleTypes.swift
//  
//
//  Created by Kevin on 7/14/23.
//

import Foundation

public typealias SimpleTupleList = [(label: String?, value: SimpleType?)]
indirect public enum SimpleType {
    case access(SimpleType?, String)
    case array([SimpleType?])
    case dict([(key: SimpleType?, value: SimpleType?)])
    case bool(Bool)
    case float(Double)
    case identifier(String)
    case int(Int)
    case `nil`
    case string(String)
    // May be a literal tuple, could also be an argument list or similar.
    case tupleList(SimpleTupleList)
}

public extension SimpleType {
    var asAccess: (SimpleType?, String)? {
        guard case .access(let simpleType, let string) = self else {
            return nil
        }
        return (simpleType, string)
    }

    var asArray: [SimpleType?]? {
        guard case .array(let array) = self else {
            return nil
        }
        return array
    }

    var asDict: [(key: SimpleType?, value: SimpleType?)]? {
        guard case .dict(let value) = self else {
            return nil
        }
        return value
    }

    var asBool: Bool? {
        guard case .bool(let value) = self else {
            return nil
        }
        return value
    }

    var asFloat: Double? {
        guard case .float(let value) = self else {
            return nil
        }
        return value
    }

    var asIdentifier: String? {
        guard case .identifier(let value) = self else {
            return nil
        }
        return value
    }

    var asInt: Int? {
        guard case .int(let value) = self else {
            return nil
        }
        return value
    }

    var isNil: Bool {
        guard case .nil = self else {
            return false
        }
        return true
    }

    var asString: String? {
        guard case .string(let value) = self else {
            return nil
        }
        return value
    }

    var asTupleList: SimpleTupleList? {
        guard case .tupleList(let value) = self else {
            return nil
        }
        return value
    }

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
