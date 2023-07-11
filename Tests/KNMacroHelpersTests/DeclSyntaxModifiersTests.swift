//
//  DeclSyntaxModifiersTests.swift
//
//
//  Created by Kevin on 7/10/23.
//

import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder
import KNMacroHelpers

final class DeclSyntaxModifiersTests: XCTestCase {
    func testAccessorDeclSyntax() {
        let decl = "mutating get { bar }" as AccessorDeclSyntax
        XCTAssertEqual(decl.getModifiers(), ["mutating"])
        XCTAssertNil(decl.getExplicitAccess())
    }

    func testActorDeclSyntax() throws {
        let d = "private actor Foo {}" as DeclSyntax
        let decl = try XCTUnwrap(d.as(ActorDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["private"])
        XCTAssertEqual(decl.getExplicitAccess(), "private")
    }

    func testAssociatedtypeDeclSyntax() throws {
        let d = "fileprivate associatedtype Foo = String" as DeclSyntax
        let decl = try XCTUnwrap(d.as(AssociatedtypeDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["fileprivate"])
        XCTAssertEqual(decl.getExplicitAccess(), "fileprivate")
    }

    func testClassDeclSyntax() throws {
        let d = "package class Foo {}" as DeclSyntax
        let decl = try XCTUnwrap(d.as(ClassDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["package"])
        XCTAssertEqual(decl.getExplicitAccess(), "package")
    }

    func testDeinitializerDeclSyntax() throws {
        let d = "public deinit {}" as DeclSyntax
        let decl = try XCTUnwrap(d.as(DeinitializerDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["public"])
        XCTAssertEqual(decl.getExplicitAccess(), "public")
    }

    func testEnumCaseDeclSyntax() throws {
        let d = "indirect case foo" as DeclSyntax
        let decl = try XCTUnwrap(d.as(EnumCaseDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["indirect"])
        XCTAssertNil(decl.getExplicitAccess())
    }

    func testEnumDeclSyntax() throws {
        let d = "private enum Foo {}" as DeclSyntax
        let decl = try XCTUnwrap(d.as(EnumDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["private"])
        XCTAssertEqual(decl.getExplicitAccess(), "private")
    }

    func testExtensionDeclSyntax() throws {
        let d = "internal extension Foo {}" as DeclSyntax
        let decl = try XCTUnwrap(d.as(ExtensionDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["internal"])
        XCTAssertEqual(decl.getExplicitAccess(), "internal")
    }

    func testFunctionDeclSyntax() throws {
        let d = "open func foo() {}" as DeclSyntax
        let decl = try XCTUnwrap(d.as(FunctionDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["open"])
        XCTAssertEqual(decl.getExplicitAccess(), "open")
    }

    func testInitializerDeclSyntax() throws {
        let d = "package init(){}" as DeclSyntax
        let decl = try XCTUnwrap(d.as(InitializerDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["package"])
        XCTAssertEqual(decl.getExplicitAccess(), "package")
    }

    func testMacroDeclSyntax() throws {
        let d = """
            public macro Foo() = #externalMacro(module: "KNMacrosMacros", type: "AutoinitMacro")
            """ as DeclSyntax
        let decl = try XCTUnwrap(d.as(MacroDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["public"])
        XCTAssertEqual(decl.getExplicitAccess(), "public")
    }

    func testProtocolDeclSyntax() throws {
        let d = "internal protocol Foo {}" as DeclSyntax
        let decl = try XCTUnwrap(d.as(ProtocolDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["internal"])
        XCTAssertEqual(decl.getExplicitAccess(), "internal")
    }

    func testStructDeclSyntax() throws {
        let d = "internal struct Foo {}" as DeclSyntax
        let decl = try XCTUnwrap(d.as(StructDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["internal"])
        XCTAssertEqual(decl.getExplicitAccess(), "internal")
    }

    func testSubscriptDeclSyntax() throws {
        let d = "internal subscript(_: Int) -> Int { 1 }" as DeclSyntax
        let decl = try XCTUnwrap(d.as(SubscriptDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["internal"])
        XCTAssertEqual(decl.getExplicitAccess(), "internal")
    }
    func testTypealiasDeclSyntax() throws {
        let d = "internal typealias Foo = String" as DeclSyntax
        let decl = try XCTUnwrap(d.as(TypealiasDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["internal"])
        XCTAssertEqual(decl.getExplicitAccess(), "internal")
    }

    func testVariableDeclSyntax() throws {
        let d = "internal var foo: Int" as DeclSyntax
        let decl = try XCTUnwrap(d.as(VariableDeclSyntax.self))
        XCTAssertEqual(decl.getModifiers(), ["internal"])
        XCTAssertEqual(decl.getExplicitAccess(), "internal")
    }

}
