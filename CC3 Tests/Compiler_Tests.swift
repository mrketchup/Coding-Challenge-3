//
//  Compiler_Tests.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/16/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import XCTest

class Compiler_Tests: XCTestCase {

    let bundle = NSBundle(forClass: Compiler_Tests.classForCoder())
    
    func testInitFromPath() {
        do {
            let path = bundle.pathForResource("Challenge", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            XCTAssertNotNil(compiler)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testInitFromData() {
        do {
            let path = bundle.pathForResource("Challenge", ofType: "cc3")!
            let data = NSData(contentsOfFile: path)!
            let compiler = try Compiler(fileData: data)
            XCTAssertNotNil(compiler)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testInitFromString() {
        do {
            let path = bundle.pathForResource("Challenge", ofType: "cc3")!
            let string = try String(contentsOfFile: path)
            let compiler = Compiler(codeString: string)
            XCTAssertNotNil(compiler)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testCompileSuccess() {
        do {
            let path = bundle.pathForResource("Test", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            let expected = [000, 212, 323, 434, 545, 656, 767, 878, 989, 090, 123, 123, 000, 100]
            XCTAssertEqual(instructions, expected)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let path = bundle.pathForResource("Challenge", ofType: "cc3")!
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
            let path = bundle.pathForResource("InvalidSyntax", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            try compiler.compile()
        } catch let error as Compiler.Error {
            if case .InvalidSyntax(let line) = error {
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
            let path = bundle.pathForResource("UnknownMethod", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            try compiler.compile()
        } catch let error as Compiler.Error {
            if case .UnknownMethod(let method, let line) = error {
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
            let path = bundle.pathForResource("IllegalArgument", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            try compiler.compile()
        } catch let error as Compiler.Error {
            if case .IllegalArgument(let argument, let line) = error {
                XCTAssertEqual(argument, "xx")
                XCTAssertEqual(line, 1)
            } else {
                XCTFail("\(error)")
            }
        } catch {
            XCTFail("\(error)")
        }
    }

}
