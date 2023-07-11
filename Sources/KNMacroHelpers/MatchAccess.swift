//
//  MatchAccess.swift
//
//
//  Created by Kevin on 7/10/23.
//

import Foundation
import SwiftSyntax

public func accessorize(to base: DeclGroupSyntax, _ list: [DeclSyntax]) -> [DeclSyntax] {
    guard let access = base.getExplicitAccess() else {
        return list
    }
    return list.map { decl in
        guard decl.getExplicitAccess() == nil else {
            return decl
        }
        return "\(raw: access) \(decl)"
    }
}
