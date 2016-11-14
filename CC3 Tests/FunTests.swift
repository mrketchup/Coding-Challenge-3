//
//  FunTests.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 6/1/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import XCTest

class FunTests: XCTestCase {

    let bundle = Bundle(for: FunTests.classForCoder())
    
    func testEqual() {
        do {
            let emulator = Emulator()
            try emulator.execute([209, 215, 100])
            
            let path = bundle.path(forResource: "Equal", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            try emulator.execute(instructions)
            XCTAssertEqual(emulator.registers[9], 0)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let emulator = Emulator()
            try emulator.execute([205, 219, 409, 415, 100])
            
            let path = bundle.path(forResource: "Equal", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            try emulator.execute(instructions)
            XCTAssertEqual(emulator.registers[9], 1)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGreaterThanOrEqual() {
        do {
            let emulator = Emulator()
            try emulator.execute([209, 215, 100])
            
            let path = bundle.path(forResource: "GreaterThanOrEqual", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            try emulator.execute(instructions)
            XCTAssertEqual(emulator.registers[9], 1)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let emulator = Emulator()
            try emulator.execute([205, 215, 100])
            
            let path = bundle.path(forResource: "GreaterThanOrEqual", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            try emulator.execute(instructions)
            XCTAssertEqual(emulator.registers[9], 1)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let emulator = Emulator()
            try emulator.execute([205, 219, 100])
            
            let path = bundle.path(forResource: "GreaterThanOrEqual", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            try emulator.execute(instructions)
            XCTAssertEqual(emulator.registers[9], 0)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testModulus() {
        do {
            let emulator = Emulator()
            try emulator.execute([209, 215, 100])
            
            let path = bundle.path(forResource: "Modulus", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            try emulator.execute(instructions)
            XCTAssertEqual(emulator.registers[9], 4)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let emulator = Emulator()
            try emulator.execute([205, 219, 100])
            
            let path = bundle.path(forResource: "Modulus", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            try emulator.execute(instructions)
            XCTAssertEqual(emulator.registers[9], 5)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let emulator = Emulator()
            try emulator.execute([209, 219, 100])
            
            let path = bundle.path(forResource: "Modulus", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            try emulator.execute(instructions)
            XCTAssertEqual(emulator.registers[9], 0)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let emulator = Emulator()
            try emulator.execute([209, 213, 100])
            
            let path = bundle.path(forResource: "Modulus", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            try emulator.execute(instructions)
            XCTAssertEqual(emulator.registers[9], 0)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testRand() {
        do {
            let seed: [Int] = try {
                let path = bundle.path(forResource: "Seed", ofType: "cc3")!
                let compiler = try Compiler(filePath: path)
                return try compiler.compile()
            }()
            
            let rand: [Int] = try {
                let path = bundle.path(forResource: "Rand", ofType: "cc3")!
                let compiler = try Compiler(filePath: path)
                return try compiler.compile()
            }()
            
            let emulator = Emulator()
            try emulator.execute(seed)
            try emulator.execute(rand)
            XCTAssertEqual(emulator.registers[0], 499)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let emulator = Emulator()
            
            let path = bundle.path(forResource: "Rand", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            
            var hits = Array(repeating: false, count: 1000)
            for _ in 0..<1000 {
                try emulator.execute(instructions)
                hits[emulator.registers[0]] = true
            }
            
            XCTAssertTrue(hits.reduce(true) { $0 && $1 })
        } catch {
            XCTFail("\(error)")
        }
    }

}
