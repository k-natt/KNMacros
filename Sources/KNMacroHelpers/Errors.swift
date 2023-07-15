//
//  Errors.swift
//
//
//  Created by Kevin on 7/12/23.
//

import Foundation
import SwiftDiagnostics

enum Errors {
    case noStringInterpolation
    case wrongCount(noun: String, actual: Int, expected: Int)
    case wrongType(actual: Any.Type, expected: Any.Type?)
}

extension Errors: DiagnosticMessage {
    var diagnosticID: MessageID {
        let id: Int
        switch self {
        case .wrongType: id = 1
        case .noStringInterpolation: id = 2
        case .wrongCount: id = 3
        }
        return MessageID(domain: "KNMacroHelperErrors", id: "\(id)")
    }

    var severity: DiagnosticSeverity { .error }

    var message: String {
        switch self {
        case .noStringInterpolation:
            return "Should not have string interpolation in a macro argument."
        case .wrongCount(let noun, let actual, let expected):
            return "Expected \(expected) \(noun)(s), found \(actual)"
        case .wrongType(actual: let actual, expected: let expected):
            return "Found unexpected type \(actual).\(expected.map{" Expected \($0)."} ?? "")"
        }
    }
}
