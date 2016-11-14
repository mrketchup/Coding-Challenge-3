//
//  Emulator_Tests.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/18/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import XCTest

class EmulatorTests: XCTestCase {
    
    func testEmulatorSuccess() {
        do {
            let emulator = Emulator()
            let executions = try emulator.execute([000, 222, 333, 444, 555, 666, 777, 888, 999, 100])
            XCTAssertEqual(executions, 10)
            XCTAssertEqual(emulator.registers, [0, 0, 2, 3, 0, 0, 0, 0, 0, 0])
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testInvalidInstruction() {
        do {
            let emulator = Emulator()
            try emulator.execute([1234])
        } catch let error as Emulator.EmulatorError {
            if case .invalidInstruction(let instruction, let address) = error {
                XCTAssertEqual(instruction, 1234)
                XCTAssertEqual(address, 0)
            } else {
                XCTFail("\(error)")
            }
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let emulator = Emulator()
            try emulator.execute([111])
        } catch let error as Emulator.EmulatorError {
            if case .invalidInstruction(let instruction, let address) = error {
                XCTAssertEqual(instruction, 111)
                XCTAssertEqual(address, 0)
            } else {
                XCTFail("\(error)")
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testMemoryOutOfBounds() {
        do {
            let emulator = Emulator()
            try emulator.execute([000])
        } catch let error as Emulator.EmulatorError {
            if case .memoryOutOfBounds = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("\(error)")
            }
        } catch {
            XCTFail("\(error)")
        }
    }

}
