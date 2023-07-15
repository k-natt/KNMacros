
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct KNMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnumAccessorMacro.self,
        AutoinitMacro.self,
        OpenMacro.self,
    ]
}
