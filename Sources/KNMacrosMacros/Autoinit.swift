//
//  Autoinit.swift
//  
//
//  Created by Kevin on 6/17/23.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum AutoinitError: Error {
    case illegalSourceCode
    case cannotDetermineName
    case cannotDetermineType
    case mismatchedTupleLengths
    case tupleNestingNotPermitted
    case tuplesNotSupported
    case tooManyArgs
    case stringLiteralOnly
}

extension AttributeSyntax.Argument {
    var isNonempty: Bool {
        self.as(TupleExprElementListSyntax.self)?.isEmpty == false
    }
}

extension VariableDeclSyntax {
    func extractNameTypeInit(from binding: PatternBindingListSyntax.Element) throws -> (name: String, type: String?, initializer: String?) {
        if let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text {
            let type = binding.typeAnnotation?.type
            let initializer = binding.initializer
            return (name: name, type: type.map{"\($0)"}, initializer: initializer.map{"\($0)"})
        } else if let nameTupleList = binding.pattern.as(TuplePatternSyntax.self)?.elements {
            _ = nameTupleList
            throw AutoinitError.tuplesNotSupported
        } else {
            throw AutoinitError.cannotDetermineName
        }
    }

    func initializables(context: any MacroExpansionContext) throws -> [(arg: String, assign: String)] {
        // Unfortunate name collision: "binding" here mostly means `name: Type [= value]`, but here we're looking for @Binding
        let attributes = self.attributes?.compactMap({ attr -> (name: String, arg: AttributeSyntax.Argument?)? in
            switch attr {
            case .attribute(let syntax):
                return syntax.attributeName.as(SimpleTypeIdentifierSyntax.self).map {
                    (name: $0.name.text, arg: syntax.argument)
                }
            case .ifConfigDecl: return nil
            }
        }) ?? []

        if attributes.contains(where: {
            $0.name != "Binding" || $0.arg?.isNonempty == true
        }) {
            // We're only handling @Binding with no args.
            return []
        }

        // Strictly speaking, if we get here we know if there's any attributes it's an @Binding so we could just check the size of the array (nonempty = @Binding).
        // But we should keep in mind that may change if we add marker annotations to explicitly include (or exclude) properties.
        if attributes.contains(where: {
            $0.name == "Binding" && $0.arg?.isNonempty != true
        }) {
            return try bindings.map { binding in
                let (name, t, initializer) = try extractNameTypeInit(from: binding)

                guard let type = t else {
                    throw AutoinitError.cannotDetermineType
                }

                // @Bindings create an underscored property that stores the actual binding, we need to assign to that.
                return ("\(name): Binding<\(type)>\(initializer ?? "")", "self._\(name) = \(name)")
            }
        }

        // Done with @Binding stuff, everything past here is declaration bindings.

        guard bindingKeyword.text != "let" else {
            var lastType: String? = nil
            return try bindings.reversed().compactMap { binding -> (String, String)? in
                let (name, type, initializer) = try extractNameTypeInit(from: binding)

                // Can't override declaration-site initialization so skip those.
                guard initializer == nil else {
                    return nil
                }

                // This is why we iterate in reverse.
                lastType = type ?? lastType
                guard let lastType else {
                    throw AutoinitError.cannotDetermineType
                }
                return ("\(name): \(lastType)".trimmingCharacters(in: .whitespacesAndNewlines), "self.\(name) = \(name)")

            }.reversed()
        }

        // Only vars without an attribute should be left.

        var lastType: String? = nil
        return try bindings.reversed().compactMap { binding -> (String, String)? in
            switch binding.accessor {
                // var foo: Type { retval }
            case .getter: return nil
                // get/set and willSet/didSet. Latter are acceptable, but must skip former pair.
            case .accessors(let block):
                if block.accessors.map(\.accessorKind.text).contains("get") {
                    return nil
                }
                break
            case .none: break
            }
            let (name, t, initializer) = try extractNameTypeInit(from: binding)
            lastType = t ?? lastType
            guard let lastType else {
                return nil
            }
            return ("\(name): \(lastType)\(initializer ?? "")".trimmingCharacters(in: .whitespacesAndNewlines), "self.\(name) = \(name)")
        }.reversed()
    }
}

public struct AutoinitMacro: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax, // @autoinit
        providingMembersOf declaration: Declaration, // @autoinit @othermacro class Foo { ... }
        in context: Context
    ) throws -> [DeclSyntax] { // init(...) { ... }
        let args = node.argument?.as(TupleExprElementListSyntax.self)
        if let count = args?.count, count > 1 {
            throw AutoinitError.tooManyArgs
        }
        let segments = args?.first?.expression.as(StringLiteralExprSyntax.self)?.segments
        if let count = segments?.count, count > 1 {
            throw AutoinitError.stringLiteralOnly
        }
        let access: String
        switch segments?.first {
        case .stringSegment(let syntax):
            access = syntax.content.text
        case .expressionSegment:
            throw AutoinitError.stringLiteralOnly
        case nil:
            access = ""
        }

        let initializables = try declaration.memberBlock.members.compactMap {
            $0.decl.as(VariableDeclSyntax.self)
        } .flatMap {
            try $0.initializables(context: context)
        }

        // Note: may at some point want to change the hardcoded space indentation to use leadingTrivia?
        return [
            """
            
            \(access.isEmpty ? "" : "\(raw: access) ")init(\(raw: initializables.map(\.arg).joined(separator: ", "))) {
                \(raw: initializables.map(\.assign).joined(separator: "\n    "))
            }
            """
        ]
    }
}
