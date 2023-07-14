//
//  DeclGroupSyntax+InheritanceHelpers.swift
//
//
//  Created by Kevin on 7/12/23.
//

import Foundation

import SwiftSyntax

extension DeclGroupSyntax {
    public func inheritsFromSimple(_ id: String) -> Bool {
        guard let inheritanceClause else {
            return false
        }
        return inheritanceClause.inheritedTypeCollection.contains { its in
            its.typeName.as(SimpleTypeIdentifierSyntax.self)?.name.text == id
        }
    }
}
