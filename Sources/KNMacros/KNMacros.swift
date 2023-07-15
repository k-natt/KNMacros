
@attached(member, names: arbitrary)
public macro autoinit(_ access: String? = nil) = #externalMacro(module: "KNMacrosMacros", type: "AutoinitMacro")

@attached(member, names: arbitrary)
@attached(conformance)
public macro openStringEnum() = #externalMacro(module: "KNMacrosMacros", type: "OpenMacro")

// Doesn't do anything itself, just used as a marker/info for openStringEnum.
@attached(member)
public macro rawValue(_: String) = #externalMacro(module: "KNMacrosMacros", type: "RawValueMacro")

@attached(member, names: arbitrary)
public macro caseAccessors() = #externalMacro(module: "KNMacrosMacros", type: "EnumAccessorMacro")
