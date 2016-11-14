//
//  Emulator.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/12/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import Foundation

class Emulator {
    
    enum EmulatorError: Error {
        case invalidInstruction(Int, address: Int)
        case memoryOutOfBounds
    }
    
    fileprivate enum PointerMutation {
        case increment
        case goto(Int)
        case halt
    }
    
    private(set) var ram = Array(repeating: 0, count: Architecture.RamSize)
    private(set) var registers: [Int] = Array(repeating: 0, count: Architecture.RegisterCount)
    
    @discardableResult
    func execute(_ instructions: [Int]) throws -> Int {
        ram = Array(repeating: 0, count: Architecture.RamSize)
        for index in 0..<min(instructions.count, Architecture.RamSize) {
            guard instructions[index] < Architecture.WordSize else {
                throw EmulatorError.invalidInstruction(instructions[index], address: index)
            }
            
            ram[index] = instructions[index]
        }
        
        var executions = 0
        var ramPointer = 0
        var halt = false
        
        while !halt {
            guard ramPointer < Architecture.RamSize else {
                throw EmulatorError.memoryOutOfBounds
            }
            
            switch try execute(ram[ramPointer], address: ramPointer) {
            case .increment:
                ramPointer += 1
            case .goto(let address):
                ramPointer = address
            case .halt:
                halt = true
            }
            
            executions += 1
        }
        
        return executions
    }
    
    private func execute(_ instruction: Int, address: Int) throws -> PointerMutation {
        guard let method = Architecture.Method(rawValue: instruction / 100) else {
            throw EmulatorError.invalidInstruction(instruction, address: address)
        }
        
        switch (method, instruction / 10 % 10, instruction % 10) {
        case (.halt, 0, 0): return .halt
        case (.set, let reg, let n): return set(reg: reg, n: n)
        case (.add, let reg, let n): return add(reg: reg, n: n)
        case (.multiply, let reg, let n): return multiply(reg: reg, n: n)
        case (.setRegister, let reg1, let reg2): return set(reg1: reg1, reg2: reg2)
        case (.addRegister, let reg1, let reg2): return add(reg1: reg1, reg2: reg2)
        case (.multiplyRegister, let reg1, let reg2): return multiply(reg1: reg1, reg2: reg2)
        case (.read, let reg1, let reg2): return read(reg1: reg1, reg2: reg2)
        case (.write, let reg1, let reg2): return write(reg1: reg1, reg2: reg2)
        case (.goto, let reg1, let reg2): return goto(reg1: reg1, reg2: reg2)
        default: throw EmulatorError.invalidInstruction(instruction, address: address)
        }
    }
    
    private func set(reg: Int, n: Int) -> PointerMutation {
        registers[reg] = n % Architecture.WordSize
        return .increment
    }
    
    private func add(reg: Int, n: Int) -> PointerMutation {
        return set(reg: reg, n: registers[reg] + n)
    }
    
    private func multiply(reg: Int, n: Int) -> PointerMutation {
        return set(reg: reg, n: registers[reg] * n)
    }
    
    private func set(reg1: Int, reg2: Int) -> PointerMutation {
        return set(reg: reg1, n: registers[reg2])
    }
    
    private func add(reg1: Int, reg2: Int) -> PointerMutation {
        return add(reg: reg1, n: registers[reg2])
    }
    
    private func multiply(reg1: Int, reg2: Int) -> PointerMutation {
        return multiply(reg: reg1, n: registers[reg2])
    }
    
    private func read(reg1: Int, reg2: Int) -> PointerMutation {
        return set(reg: reg1, n: ram[registers[reg2]])
    }
    
    private func write(reg1: Int, reg2: Int) -> PointerMutation {
        ram[registers[reg2]] = registers[reg1]
        return .increment
    }
    
    private func goto(reg1: Int, reg2: Int) -> PointerMutation {
        guard registers[reg2] > 0 else {
            return .increment
        }
        
        return .goto(registers[reg1])
    }
    
}
