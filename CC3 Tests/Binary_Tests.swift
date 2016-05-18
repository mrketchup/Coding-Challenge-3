//
//  Binary_Tests.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/17/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import XCTest

extension NSData {
    
    var byteArray: [UInt8] {
        let ptr = UnsafePointer<UInt8>(bytes)
        var array: [UInt8] = []
        for i in 0..<length {
            array.append(ptr[i])
        }
        
        return array
    }
    
}

class Binary_Tests: XCTestCase {

    func testBinaryWriterSuccess() {
        do {
            let writer = BinaryWriter()
            let data = try writer.encode(instructions: [000, 001, 002, 997, 998, 999])
            XCTAssertEqual(data.byteArray, [0x00, 0x00, 0x10, 0x0B, 0xE5, 0xF9, 0xBE, 0x70])
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let writer = BinaryWriter()
            let data = try writer.encode(instructions: [111, 222, 333, 444, 555, 666, 777, 888, 999, 000])
            XCTAssertEqual(data.byteArray, [0x1B, 0xCD, 0xE5, 0x35, 0xBC, 0x8A, 0xE9, 0xAC, 0x27, 0x78, 0xF9, 0xC0, 0x00])
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let writer = BinaryWriter()
            let data = try writer.encode(instructions: [])
            XCTAssertEqual(data.byteArray, [])
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testBinaryWriterTooManyInstructions() {
        do {
            let writer = BinaryWriter()
            try writer.encode(instructions: Array(count: 1234, repeatedValue: 101))
        } catch let error as BinaryWriter.Error {
            if case .TooManyInstructions(let count) = error {
                XCTAssertEqual(count, 1234)
            } else {
                XCTFail("\(error)")
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testBinaryWriterInvalidInstruction() {
        do {
            let writer = BinaryWriter()
            try writer.encode(instructions: [000, 001, 1234, 997, 998, 999])
        } catch let error as BinaryWriter.Error {
            if case .InvalidInstruction(let instruction, let index) = error {
                XCTAssertEqual(instruction, 1234)
                XCTAssertEqual(index, 2)
            } else {
                XCTFail("\(error)")
            }
        } catch {
            XCTFail("\(error)")
        }
    }

}
