
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct KNMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AutoinitMacro.self,
        DummyMacroMakerMacro.self,
        OpenMacro.self,
        SimpleConformanceMacroMakerMacro.self,
    ]
}
