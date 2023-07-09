//
//  VariableDeclSyntax+hasAttribute.swift
//  
//
//  Created by Kevin on 7/5/23.
//

import Foundation
import SwiftSyntax

extension VariableDeclSyntax {
    public func hasAttribute(_ name: String) -> Bool {
        attributes?.contains { el in
            switch el {
            case .attribute(let syn):
                return syn.attributeName.as(SimpleTypeIdentifierSyntax.self)?.name.text == name
            case .ifConfigDecl:
                return false
            }
        } == true
    }
}
