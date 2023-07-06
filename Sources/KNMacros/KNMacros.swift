
@attached(member, names: arbitrary)
public macro autoinit(_: String? = nil) = #externalMacro(module: "KNMacrosMacros", type: "AutoinitMacro")

@attached(member, names: arbitrary)
@attached(conformance)
public macro openStringEnum() = #externalMacro(module: "KNMacrosMacros", type: "OpenMacro")

// Doesn't do anything itself, just used as a marker/info for openStringEnum.
@attached(member)
public macro rawValue(_: String) = #externalMacro(module: "KNMacrosMacros", type: "RawValueMacro")

// Adds all conformances, so resulting macro can be used anywhere.
@attached(member, names: named(expansion))
@attached(conformance)
public macro dummyMacro() = #externalMacro(module: "KNMacrosMacros", type: "DummyMacroMakerMacro")

@attached(member, names: named(expansion))
@attached(conformance)
public macro conformer(to: String, with: String...) = #externalMacro(module: "KNMacrosMacros", type: "SimpleConformanceMacroMakerMacro")
