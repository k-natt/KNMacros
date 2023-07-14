//
//  Errors.swift
//
//
//  Created by Kevin on 7/12/23.
//

import Foundation
import SwiftDiagnostics

enum Errors {
    case wrongType(actual: Any.Type, expected: Any.Type?)
    case noStringInterpolation
}

extension Errors: DiagnosticMessage {
    var diagnosticID: MessageID {
        let id: Int
        switch self {
        case .wrongType: id = 1
        case .noStringInterpolation: id = 2
        }
        return MessageID(domain: "KNMacroHelperErrors", id: "\(id)")
    }

    var severity: DiagnosticSeverity { .error }

    var message: String {
        switch self {
        case .wrongType(actual: let actual, expected: let expected):
            return "Found unexpected type \(actual).\(expected.map{" Expected \($0)."} ?? "")"
        case .noStringInterpolation:
            return "Should not have string interpolation in a macro argument."
        }
    }
}
