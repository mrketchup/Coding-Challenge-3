//
//  Emulator.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/12/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import Foundation

class Emulator {
    
    enum Error: ErrorType {
        case InvalidInstruction(Int, address: Int)
        case MemoryOutOfBounds
    }
    
    enum PointerMutation {
        case Increment
        case Goto(Int)
        case Halt
    }
    
    private(set) var ram = Array(count: Architecture.RamSize, repeatedValue: 0)
    private(set) var registers: [Int] = Array(count: Architecture.RegisterCount, repeatedValue: 0)
    
    func execute(instructions: [Int]) throws -> Int {
        ram = Array(count: Architecture.RamSize, repeatedValue: 0)
        for index in 0..<min(instructions.count, Architecture.RamSize) {
            guard instructions[index] < Architecture.WordSize else {
                throw Error.InvalidInstruction(instructions[index], address: index)
            }
            
            ram[index] = instructions[index]
        }
        
        var executions = 0
        var ramPointer = 0
        var halt = false
        
        while !halt {
            guard ramPointer < Architecture.RamSize else {
                throw Error.MemoryOutOfBounds
            }
            
            switch try execute(ram[ramPointer], address: ramPointer) {
            case .Increment:
                ramPointer += 1
            case .Goto(let address):
                ramPointer = address
            case .Halt:
                halt = true
            }
            
            executions += 1
        }
        
        return executions
    }
    
    func execute(instruction: Int, address: Int) throws -> PointerMutation {
        guard let method = Architecture.Method(rawValue: instruction / 100) else {
            throw Error.InvalidInstruction(instruction, address: address)
        }
        
        switch (method, instruction / 10 % 10, instruction % 10) {
        case (.Halt, 0, 0): return .Halt
        case (.Set, let reg, let n): return set(reg: reg, n: n)
        case (.Add, let reg, let n): return add(reg: reg, n: n)
        case (.Multiply, let reg, let n): return multiply(reg: reg, n: n)
        case (.SetRegister, let reg1, let reg2): return set(reg1: reg1, reg2: reg2)
        case (.AddRegister, let reg1, let reg2): return add(reg1: reg1, reg2: reg2)
        case (.MultiplyRegister, let reg1, let reg2): return multiply(reg1: reg1, reg2: reg2)
        case (.Read, let reg1, let reg2): return read(reg1: reg1, reg2: reg2)
        case (.Write, let reg1, let reg2): return write(reg1: reg1, reg2: reg2)
        case (.Goto, let reg1, let reg2): return goto(reg1: reg1, reg2: reg2)
        default: throw Error.InvalidInstruction(instruction, address: address)
        }
    }
    
    func set(reg reg: Int, n: Int) -> PointerMutation {
        registers[reg] = n % Architecture.WordSize
        return .Increment
    }
    
    func add(reg reg: Int, n: Int) -> PointerMutation {
        return set(reg: reg, n: registers[reg] + n)
    }
    
    func multiply(reg reg: Int, n: Int) -> PointerMutation {
        return set(reg: reg, n: registers[reg] * n)
    }
    
    func set(reg1 reg1: Int, reg2: Int) -> PointerMutation {
        return set(reg: reg1, n: registers[reg2])
    }
    
    func add(reg1 reg1: Int, reg2: Int) -> PointerMutation {
        return add(reg: reg1, n: registers[reg2])
    }
    
    func multiply(reg1 reg1: Int, reg2: Int) -> PointerMutation {
        return multiply(reg: reg1, n: registers[reg2])
    }
    
    func read(reg1 reg1: Int, reg2: Int) -> PointerMutation {
        return set(reg: reg1, n: ram[registers[reg2]])
    }
    
    func write(reg1 reg1: Int, reg2: Int) -> PointerMutation {
        ram[registers[reg2]] = registers[reg1]
        return .Increment
    }
    
    func goto(reg1 reg1: Int, reg2: Int) -> PointerMutation {
        guard registers[reg2] > 0 else {
            return .Increment
        }
        
        return .Goto(registers[reg1])
    }
    
}
