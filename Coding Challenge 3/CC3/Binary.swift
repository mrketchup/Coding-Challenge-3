//
//  Binary.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/17/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import Foundation

class BinaryWriter {
    
    enum BinaryWriterError: Error {
        case tooManyInstructions(Int)
        case invalidInstruction(Int, index: Int)
    }
    
    private var data = Data()
    private var outByte: UInt8 = 0
    private var outCount = 0
    
    func encode(instructions: [Int]) throws -> Data {
        data = Data()
        outByte = 0
        outCount = 0
        
        guard instructions.count <= Architecture.RamSize else {
            throw BinaryWriterError.tooManyInstructions(instructions.count)
        }
        
        for index in 0..<instructions.count {
            guard instructions[index] < Architecture.WordSize else {
                throw BinaryWriterError.invalidInstruction(instructions[index], index: index)
            }
            
            for bit in binaryArray(UInt16(instructions[index])) {
                write(bit: bit)
            }
        }
        
        flush()
        return data as Data
    }
    
    private func binaryArray(_ instruction: UInt16) -> [Bool] {
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
    
    private func write(bit: Bool) {
        if outCount == 8 {
            data.append(&outByte, count: 1)
            outCount = 0
        }
        
        outByte = (outByte << 1) | (bit ? 1 : 0)
        outCount += 1
    }
    
    private func flush() {
        guard outCount > 0 else {
            return
        }
        
        if outCount < 8 {
            outByte <<= UInt8(8 - outCount)
        }
        
        data.append(&outByte, count: 1)
    }
    
}


class BinaryReader {
    
    enum BinaryReaderError: Error {
        case instructionOverflow
    }
    
    private var pointer: UnsafePointer<UInt8>? = nil
    private var inByte: UInt8 = 0
    private var inCount = 8
    
    func decode(data: Data) throws -> [Int] {
        pointer = (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count)
        inByte = 0
        inCount = 8
        
        var instructions: [Int] = []
        var buffer: [Bool] = []
        
        for _ in 0..<(data.count * 8) {
            buffer.append(readBit())
            
            if buffer.count == Architecture.DigitSize {
                var instruction = 0
                for bit in buffer {
                    instruction <<= 1
                    instruction += bit ? 1 : 0
                }
                
                buffer = []
                instructions.append(instruction)
                if instructions.count > Architecture.RamSize {
                    throw BinaryReaderError.instructionOverflow
                }
            }
        }
        
        return instructions
    }
    
    private func readBit() -> Bool {
        if inCount == 8 {
            inCount = 0
            inByte = pointer?.pointee ?? 0
            pointer = pointer?.successor()
        }
        
        let bit = inByte & 0b10000000
        inByte <<= 1
        inCount += 1
        return bit != 0
    }
    
}
