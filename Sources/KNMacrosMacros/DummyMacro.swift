//
//  DummyMacro.swift
//
//
//  Created by Kevin on 7/5/23.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct DummyMacro: MemberAttributeMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        []
    }
}
