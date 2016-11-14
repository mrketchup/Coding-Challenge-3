//
//  Challenge_Tests.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/24/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import XCTest

class ChallengeTests: XCTestCase {

    let bundle = Bundle(for: ChallengeTests.classForCoder())
    
    func testCodingChallenge() {
        do {
            let path = bundle.path(forResource: "Challenge", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            let emulator = Emulator()
            let executions = try emulator.execute(instructions)
            XCTAssertEqual(executions, 16)
            XCTAssertEqual(emulator.registers, [0, 0, 0, 0, 0, 0, 0, 9, 0, 999])
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let path = bundle.path(forResource: "Pretty Challenge", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            let emulator = Emulator()
            let executions = try emulator.execute(instructions)
            XCTAssertEqual(executions, 16)
            XCTAssertEqual(emulator.registers, [0, 0, 0, 0, 0, 0, 0, 9, 0, 999])
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testCodingChallenge42() {
        do {
            let path = bundle.path(forResource: "Challenge42", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            let emulator = Emulator()
            let executions = try emulator.execute(instructions)
            XCTAssertEqual(executions, 42)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testCodingChallenge1000() {
        do {
            let path = bundle.path(forResource: "Challenge1000", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            let emulator = Emulator()
            let executions = try emulator.execute(instructions)
            XCTAssertEqual(executions, 1000)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testCodingChallenge1234() {
        do {
            let path = bundle.path(forResource: "Challenge1234", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            let emulator = Emulator()
            let executions = try emulator.execute(instructions)
            XCTAssertEqual(executions, 1234)
        } catch {
            XCTFail("\(error)")
        }
    }

}
