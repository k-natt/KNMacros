import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import KNMacrosMacros

private let testMacros: [String: Macro.Type] = [
    "autoinit": AutoinitMacro.self,
]

final class AutoinitTests: XCTestCase {
    func testAutoinit_letSimpleTypeSingle() {
        assertMacroExpansion(
            """
            @autoinit class Foo {
                let foo: Foo
                let bar: Generic<Bar>
            }
            """,
            expandedSource: """
            class Foo {
                let foo: Foo
                let bar: Generic<Bar>
                init(foo: Foo, bar: Generic<Bar>) {
                    self.foo = foo
                    self.bar = bar
                }
            }
            """, macros: testMacros
        )
    }

    func testAutoinit_letSugarTypeSingle() {
        assertMacroExpansion(
            """
            @autoinit class Foo {
                let foo: Foo?
                let bar: [Bar: Foo]
            }
            """,
            expandedSource: """
            class Foo {
                let foo: Foo?
                let bar: [Bar: Foo]
                init(foo: Foo?, bar: [Bar: Foo]) {
                    self.foo = foo
                    self.bar = bar
                }
            }
            """, macros: testMacros
        )
    }

    func testAutoinit_letSimpleList() {
        assertMacroExpansion(
            """
            @autoinit class Foo {
                let foo, bar: String, baz, quux: Int
            }
            """,
            expandedSource: """
            class Foo {
                let foo, bar: String, baz, quux: Int
                init(foo: String, bar: String, baz: Int, quux: Int) {
                    self.foo = foo
                    self.bar = bar
                    self.baz = baz
                    self.quux = quux
                }
            }
            """, macros: testMacros
        )
    }

    func NYI_testAutoinit_letTuple() {
        assertMacroExpansion(
            """
            @autoinit class Foo {
                let (foo, (bar, baz)): (Int, (String, Double))
            }
            """,
            expandedSource: """
            class Foo {
                let (foo, bar): (Int, String)
                init(foo: Int, bar: String, baz: Double) {
                    self.foo = foo
                    self.bar = bar
                    self.baz = baz
                }
            }
            """, macros: testMacros
        )
    }

    func testAutoinit_letWithInitializers() {
        assertMacroExpansion(
            """
            @autoinit class Foo {
                let foo: Int = 1
                let bar = 2
            }
            """,
            expandedSource: """
            class Foo {
                let foo: Int = 1
                let bar = 2
                init() {
            
                }
            }
            """, macros: testMacros
        )
        
        assertMacroExpansion(
            """
            @autoinit class Foo {
                let foo = 3 as Int?
                let bar = 4 as! String
                let baz = 5 as? String?
            }
            """,
            expandedSource: """
            class Foo {
                let foo = 3 as Int?
                let bar = 4 as! String
                let baz = 5 as? String?
                init() {
            
                }
            }
            """, macros: testMacros
        )
    }

    func NYI_testAutoinit_letTupleDecls() {
        assertMacroExpansion(
            """
            @autoinit class Foo {
                let (foo, bar): (Int, String)
                let (baz, quux): (Int, String) = (6, "7")
                let (corge, grault) = (8, "9")
            }
            """,
            expandedSource: """
            class Foo {
                let (foo, bar): (Int, String)
                let (baz, quux): (Int, String) = (6, "7")
                let (corge, grault) = (8, "9")
                init(foo: Int, bar: String) {

                }
            }
            """, macros: testMacros
        )
    }

    func NYI_testAutoinit_varTupleDecls() {
        assertMacroExpansion(
            """
            @autoinit class Foo {
                var (foo, bar): (Int, String?)
                var ((baz, quux), grault) = ((6, "7" as! Int), 8 as Double)
            }
            """,
            expandedSource: """
            class Foo {
                var (foo, bar): (Int, String?)
                var ((baz, quux), grault) = ((6, "7" as! Int), 8 as Double)
                init(foo: Int, bar: String? = nil) {
                    self.foo = foo
                    self.bar = bar
                }
            }
            """, macros: testMacros
        )
    }

    func testAutoinit_varExplicitTypeNoInitNoAccessor() {
        assertMacroExpansion(
            """
            @autoinit class Foo {
                var foo: Int
                var bar: Int?
                var baz, quux: String
                var corge: Int, grault: String
            }
            """,
            expandedSource: """
            class Foo {
                var foo: Int
                var bar: Int?
                var baz, quux: String
                var corge: Int, grault: String
                init(foo: Int, bar: Int?, baz: String, quux: String, corge: Int, grault: String) {
                    self.foo = foo
                    self.bar = bar
                    self.baz = baz
                    self.quux = quux
                    self.corge = corge
                    self.grault = grault
                }
            }
            """, macros: testMacros
        )
    }

    func testAutoinit_varExplicitTypeInitNoAccessor() {
        // Can't have an initializer on baz because it isn't necessarily the same type then.
        assertMacroExpansion(
            """
            @autoinit class Foo {
                var foo: Int = 1
                var bar: Int? = 2
                var baz, quux: String = "3"
                var corge: Int = 4, grault: String = "5"
            }
            """,
            expandedSource: """
            class Foo {
                var foo: Int = 1
                var bar: Int? = 2
                var baz, quux: String = "3"
                var corge: Int = 4, grault: String = "5"
                init(foo: Int = 1, bar: Int? = 2, baz: String, quux: String = "3", corge: Int = 4, grault: String = "5") {
                    self.foo = foo
                    self.bar = bar
                    self.baz = baz
                    self.quux = quux
                    self.corge = corge
                    self.grault = grault
                }
            }
            """, macros: testMacros
        )
    }

    func testAutoinit_varAccessors() {
        assertMacroExpansion(
            """
            @autoinit class Foo {
                var foo: Int {
                    return 1
                }
                var bar: Int {
                    willSet {}
                    didSet {}
                }
                var baz: Int = 2 {
                    willSet {}
                    didSet {}
                }
                var corge: Int {
                    get { 5 }
                }
                var grault: String {
                    willSet {}
                    get { "5" }
                }
            }
            """,
            expandedSource: """
            class Foo {
                var foo: Int {
                    return 1
                }
                var bar: Int {
                    willSet {
                    }
                    didSet {
                    }
                }
                var baz: Int = 2 {
                    willSet {
                    }
                    didSet {
                    }
                }
                var corge: Int {
                    get {
                        5
                    }
                }
                var grault: String {
                    willSet {
                    }
                    get {
                        "5"
                    }
                }
                init(bar: Int, baz: Int = 2) {
                    self.bar = bar
                    self.baz = baz
                }
            }
            """, macros: testMacros
        )
    }

    func NYI_testAutoinit_varNoType() {
        // Hopefully some day we'll be able to handle some or all of these but it doesn't seem likely for most for now.
        assertMacroExpansion(
            """
            @autoinit class Foo {
                var foo = 1
                var bar = 2 as Int
                var baz = 3 as Int?, quux = "4" as! String
            }
            """,
            expandedSource: """
            class Foo {
                var foo = 1
                var bar = 2 as Int
                var baz = 3 as Int?, quux = "4" as! String
                init(foo: Int = 1, bar: Int? = 2, baz: Int? = 3, quux: String = "4") {
                    self.foo = foo
                    self.bar = bar
                    self.baz = baz
                    self.quux = quux
                }
            }
            """, macros: testMacros
        )
    }

    func testAutoinit_Binding() {
        assertMacroExpansion(
            """
            @autoinit class Foo {
                @Binding var foo: Int
                @Transient @Binding var bar: Int? = 2
                @Binding @Transient var baz: Int
                @Binding(get: {1}, set: { _ in}) var quux: Int
                @Binding() var corge: Int
            }
            """,
            expandedSource: """
            class Foo {
                @Binding var foo: Int
                @Transient @Binding var bar: Int? = 2
                @Binding @Transient var baz: Int
                @Binding(get: {
                    1
                }, set: { _ in
                }) var quux: Int
                @Binding() var corge: Int
                init(foo: Binding<Int>, corge: Binding<Int>) {
                    self._foo = foo
                    self._corge = corge
                }
            }
            """, macros: testMacros
        )
    }

    func testModifier() {
        assertMacroExpansion("""
        @autoinit("public")
        public class Foo {
            let bar: Int
        }
        """, expandedSource: """
        public class Foo {
            let bar: Int
            public init(bar: Int) {
                self.bar = bar
            }
        }
        """, macros: testMacros)
    }
}
