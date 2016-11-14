//
//  Compiler_Tests.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/16/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import XCTest

class CompilerTests: XCTestCase {

    let bundle = Bundle(for: CompilerTests.classForCoder())
    
    func testInitFromPath() {
        do {
            let path = bundle.path(forResource: "Challenge", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            XCTAssertNotNil(compiler)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testInitFromData() {
        do {
            let path = bundle.path(forResource: "Challenge", ofType: "cc3")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let compiler = try Compiler(fileData: data)
            XCTAssertNotNil(compiler)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testInitFromString() {
        do {
            let path = bundle.path(forResource: "Challenge", ofType: "cc3")!
            let string = try String(contentsOfFile: path)
            let compiler = Compiler(codeString: string)
            XCTAssertNotNil(compiler)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testCompileSuccess() {
        do {
            let path = bundle.path(forResource: "Test", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            let expected = [000, 212, 323, 434, 545, 656, 767, 878, 989, 090, 123, 123, 000, 100]
            XCTAssertEqual(instructions, expected)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let path = bundle.path(forResource: "Challenge", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            let expected = [299, 492, 495, 399, 492, 495, 399, 283, 279, 689, 078, 100, 000, 000, 000]
            XCTAssertEqual(instructions, expected)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testCompileInvalidSyntax() {
        do {
            let compiler = Compiler(codeString: "derpyderp")
            _ = try compiler.compile()
        } catch let error as Compiler.CompilerError {
            if case .invalidSyntax(let line) = error {
                XCTAssertEqual(line, 1)
            } else {
                XCTFail("\(error)")
            }
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let compiler = Compiler(codeString: "raw 123 123")
            _ = try compiler.compile()
        } catch let error as Compiler.CompilerError {
            if case .invalidSyntax(let line) = error {
                XCTAssertEqual(line, 1)
            } else {
                XCTFail("\(error)")
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testCompileUnknownMethod() {
        do {
            let compiler = Compiler(codeString: "derp 1 2")
            _ = try compiler.compile()
        } catch let error as Compiler.CompilerError {
            if case .unknownMethod(let method, let line) = error {
                XCTAssertEqual(method, "derp")
                XCTAssertEqual(line, 1)
            } else {
                XCTFail("\(error)")
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testCompileIllegalArgument() {
        do {
            let compiler = Compiler(codeString: "add xx 0")
            _ = try compiler.compile()
        } catch let error as Compiler.CompilerError {
            if case .illegalArgument(let argument, let line) = error {
                XCTAssertEqual(argument, "xx")
                XCTAssertEqual(line, 1)
            } else {
                XCTFail("\(error)")
            }
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let compiler = Compiler(codeString: "set 5 99")
            _ = try compiler.compile()
        } catch let error as Compiler.CompilerError {
            if case .illegalArgument(let argument, let line) = error {
                XCTAssertEqual(argument, "99")
                XCTAssertEqual(line, 1)
            } else {
                XCTFail("\(error)")
            }
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let compiler = Compiler(codeString: "raw 1234")
            _ = try compiler.compile()
        } catch let error as Compiler.CompilerError {
            if case .illegalArgument(let argument, let line) = error {
                XCTAssertEqual(argument, "1234")
                XCTAssertEqual(line, 1)
            } else {
                XCTFail("\(error)")
            }
        } catch {
            XCTFail("\(error)")
        }
    }

}
