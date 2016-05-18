//
//  Binary.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/17/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import Foundation

class BinaryWriter {
    
    enum Error: ErrorType {
        case TooManyInstructions(Int)
        case InvalidInstruction(Int, index: Int)
    }
    
    var data = NSMutableData()
    var outByte: UInt8 = 0
    var outCount = 0
    
    func encode(instructions instructions: [Int]) throws -> NSData {
        guard instructions.count < Architecture.RamSize else {
            throw Error.TooManyInstructions(instructions.count)
        }
        
        for index in 0..<instructions.count {
            guard instructions[index] < Architecture.WordSize else {
                throw Error.InvalidInstruction(instructions[index], index: index)
            }
            
            for bit in binaryArray(UInt16(instructions[index])) {
                write(bit: bit)
            }
        }
        
        flush()
        return data
    }
    
    func binaryArray(instruction: UInt16) -> [Bool] {
        return [
            instruction & 0b1000000000 > 0,
            instruction & 0b0100000000 > 0,
            instruction & 0b0010000000 > 0,
            instruction & 0b0001000000 > 0,
            instruction & 0b0000100000 > 0,
            instruction & 0b0000010000 > 0,
            instruction & 0b0000001000 > 0,
            instruction & 0b0000000100 > 0,
            instruction & 0b0000000010 > 0,
            instruction & 0b0000000001 > 0
        ]
    }
    
    func write(bit bit: Bool) {
        if outCount == 8 {
            data.appendBytes(&outByte, length: 1)
            outCount = 0
        }
        
        outByte = (outByte << 1) | (bit ? 1 : 0)
        outCount += 1
    }
    
    func flush() {
        guard outCount > 0 else {
            return
        }
        
        if outCount < 8 {
            outByte <<= UInt8(8 - outCount)
        }
        
        data.appendBytes(&outByte, length: 1)
    }
    
}


class BinaryReader {
    
    func decode(data data: NSData) throws -> [Int] {
        return []
    }
    
}
