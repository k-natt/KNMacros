import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct KNMacroHelpersPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DiagnosticMacro.self,
        DummyMacroMakerMacro.self,
        SimpleConformanceMacroMakerMacro.self
    ]
}
