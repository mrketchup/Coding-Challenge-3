//
//  Binary_Tests.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/17/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import XCTest

extension Data {
    
    var byteArray: [UInt8] {
        var array: [UInt8] = []
        for byte in self {
            array.append(byte)
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
            _ = try writer.encode(instructions: Array(repeating: 101, count: 1234))
        } catch let error as BinaryWriter.BinaryWriterError {
            if case .tooManyInstructions(let count) = error {
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
            _ = try writer.encode(instructions: [000, 001, 1234, 997, 998, 999])
        } catch let error as BinaryWriter.BinaryWriterError {
            if case .invalidInstruction(let instruction, let index) = error {
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
            let instructions = try reader.decode(data: Data())
            XCTAssertEqual(instructions, [])
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            var data = Data()
            data.append(UnsafePointer([0x00]), count: 1)
            data.append(UnsafePointer([0x00]), count: 1)
            data.append(UnsafePointer([0x10]), count: 1)
            data.append(UnsafePointer([0x0B]), count: 1)
            data.append(UnsafePointer([0xE5]), count: 1)
            data.append(UnsafePointer([0xF9]), count: 1)
            data.append(UnsafePointer([0xBE]), count: 1)
            data.append(UnsafePointer([0x70]), count: 1)
            let reader = BinaryReader()
            let instructions = try reader.decode(data: data)
            XCTAssertEqual(instructions, [000, 001, 002, 997, 998, 999])
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let writer = BinaryWriter()
            let instructions = Array(repeating: 101, count: Architecture.RamSize)
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
            let instructions = Array(repeating: 101, count: Architecture.RamSize)
            var data = try writer.encode(instructions: instructions)
            data.append(UnsafePointer([0x10]), count: 1)
            data.append(UnsafePointer([0x10]), count: 1)
            let reader = BinaryReader()
            _ = try reader.decode(data: data)
        } catch let error as BinaryReader.BinaryReaderError {
            XCTAssertTrue(error == .instructionOverflow)
        } catch {
            XCTFail("\(error)")
        }
    }

}
