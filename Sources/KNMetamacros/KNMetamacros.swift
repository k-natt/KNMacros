
// Adds all conformances, so resulting macro can be used anywhere.
@attached(member, names: named(expansion))
@attached(conformance)
public macro dummyMacro() = #externalMacro(module: "KNMetamacrosMacros", type: "DummyMacroMakerMacro")

@attached(member, names: named(expansion))
@attached(conformance)
public macro conformer(to: String, with: String...) = #externalMacro(module: "KNMetamacrosMacros", type: "SimpleConformanceMacroMakerMacro")

@attached(member, names: named(diagnosticID), named(message), named(severity), named(asDiagnosticError))
@attached(conformance)
public macro diagnostic() = #externalMacro(module: "KNMetamacrosMacros", type: "DiagnosticMacro")
