
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct KNMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AutoinitMacro.self,
        OpenMacro.self,
    ]
}
