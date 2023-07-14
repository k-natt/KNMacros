//
//  DeclGroupSyntax+EnumHelpers.swift
//
//
//  Created by Kevin on 7/9/23.
//

import Foundation
import SwiftSyntax

extension DeclGroupSyntax {
    // Returns nil if not enum, case names otherwise. Associated values ignored.
    public func caseNamesIfEnum() -> [String]? {
        guard let enumDecl = self.as(EnumDeclSyntax.self) else {
            return nil
        }
        return enumDecl.memberBlock.members.compactMap { member in
            member.decl.as(EnumCaseDeclSyntax.self)?.elements.map(\.identifier.text)
        }.flatMap{$0}
    }
}
