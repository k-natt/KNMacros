//
//  EnumAccessorMacro.swift
//
//
//  Created by Kevin on 7/14/23.
//

import Foundation
import KNMacroHelpers
import SwiftSyntax
import SwiftSyntaxMacros

public enum EnumAccessorMacro {}

extension EnumAccessorMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let caseDecls = declaration.memberBlock.members.compactMap {
            $0.decl.as(EnumCaseDeclSyntax.self)
        }
        return accessorize(to: declaration, caseDecls.flatMap(\.elements).map { caseDecl -> DeclSyntax in
            let name = caseDecl.identifier.text.trimmingCharacters(in: .init(charactersIn: "`"))
            guard let av = caseDecl.associatedValue,
                  let firstArg = av.parameterList.first else {
                return """
                var is\(raw: name.uppercaseFirstLetter()): Bool {
                    guard case .\(raw: name) = self else {
                        return false
                    }
                    return true
                }
                """
            }
            let args = av.parameterList
            if args.count == 1 {
                return """
                var as\(raw: name.uppercaseFirstLetter()): \(raw: firstArg.type)? {
                    guard case .\(raw: name)(let value) = self else {
                        return nil
                    }
                    return value
                }
                """
            } else {
                let names = args.enumerated().map { (idx, el) in
                    el.usableName() ?? "value\(idx)"
                }
                let decls = names.map({ "let \($0)" })
                return """
                var as\(raw: name.uppercaseFirstLetter()): \(av)? {
                    guard case .\(raw: name)(\(raw: decls.joined(separator: ", "))) = self else {
                        return nil
                    }
                    return (\(raw: names.joined(separator: ", ")))
                }
                """
            }
        })
    }
}
