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

class BinaryTests: XCTestCase {

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
    
    func testBinaryReaderSuccess() {
        do {
            let reader = BinaryReader()
            let instructions = try reader.decode(data: NSData())
            XCTAssertEqual(instructions, [])
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let data = NSMutableData()
            data.appendBytes(UnsafePointer([0x00]), length: 1)
            data.appendBytes(UnsafePointer([0x00]), length: 1)
            data.appendBytes(UnsafePointer([0x10]), length: 1)
            data.appendBytes(UnsafePointer([0x0B]), length: 1)
            data.appendBytes(UnsafePointer([0xE5]), length: 1)
            data.appendBytes(UnsafePointer([0xF9]), length: 1)
            data.appendBytes(UnsafePointer([0xBE]), length: 1)
            data.appendBytes(UnsafePointer([0x70]), length: 1)
            let reader = BinaryReader()
            let instructions = try reader.decode(data: data)
            XCTAssertEqual(instructions, [000, 001, 002, 997, 998, 999])
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let writer = BinaryWriter()
            let instructions = Array(count: Architecture.RamSize, repeatedValue: 101)
            let data = try writer.encode(instructions: instructions)
            let reader = BinaryReader()
            XCTAssertEqual(instructions, try reader.decode(data: data))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testBinaryReaderInstructionOverflow() {
        do {
            let writer = BinaryWriter()
            let instructions = Array(count: Architecture.RamSize, repeatedValue: 101)
            let data = NSMutableData(data: try writer.encode(instructions: instructions))
            data.appendBytes(UnsafePointer([0x10]), length: 1)
            data.appendBytes(UnsafePointer([0x10]), length: 1)
            let reader = BinaryReader()
            try reader.decode(data: data)
        } catch let error as BinaryReader.Error {
            XCTAssertTrue(error == .InstructionOverflow)
        } catch {
            XCTFail("\(error)")
        }
    }

}
