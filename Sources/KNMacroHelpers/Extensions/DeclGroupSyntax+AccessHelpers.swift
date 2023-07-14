//
//  DeclGroupSyntax+AccessHelpers.swift
//
//
//  Created by Kevin on 7/12/23.
//

import Foundation
import SwiftSyntax

public enum AccessModifier: String, CaseIterable {
    case `fileprivate`
    case `internal`
    case `open`
    case `package`
    case `private`
    case `public`

    public static var all: Set<String> {
        Set(Self.allCases.map(\.rawValue))
    }
}

extension SyntaxProtocol {
    public func getExplicitAccess() -> String? {
        getModifiers()?.first(where: {
            AccessModifier.all.contains($0)
        })
    }

    public func getModifiers() -> [String]? {
        switch Self.structure {
        case .collection:
            // Collections can't have modifiers.
            break

        case .choices(let choices):
            for choice in choices {
                switch choice {
                case .node(let proto):
                    if let typedSelf = self.as(proto) {
                        return typedSelf.getModifiers()
                    }
                case .token:
                    continue
                }
            }

        case .layout(let layout):
            for kp in layout {
                guard let value = self[keyPath: kp] else {
                    continue
                }
                if let rawMod = value as? DeclModifierSyntax {
                    // Single modifier
                    return [rawMod.name.text]
                } else if let modList = value as? ModifierListSyntax {
                    return modList.map(\.name.text)
                }
            }
        }
        return nil
    }
}
