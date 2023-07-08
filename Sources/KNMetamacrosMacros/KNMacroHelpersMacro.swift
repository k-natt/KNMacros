import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct KNMacroHelpersPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DummyMacroMakerMacro.self,
        SimpleConformanceMacroMakerMacro.self
    ]
}
