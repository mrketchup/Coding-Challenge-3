//
//  Spec.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/12/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

enum Architecture {
    
    static let RamSize = 1000
    static let WordSize = 1000
    static let DigitSize = 10
    static let RegisterCount = 10
    
    enum Method: Int {
        case goto = 0
        case halt
        case set
        case add
        case multiply
        case setRegister
        case addRegister
        case multiplyRegister
        case read
        case write
    }
    
}

enum Language {
    
    static let CommentSymbol = "#"
    
    enum SpecialMethod {
        static let Exit = "exit"
        static let Null = "null"
        static let Raw = "raw"
    }
    
    enum Method: String {
        
        case Goto = "goto"
        case Set = "set"
        case Add = "add"
        case Multiply = "mult"
        case SetRegister = "set_reg"
        case AddRegister = "add_reg"
        case MultiplyRegister = "mult_reg"
        case Read = "read"
        case Write = "write"
        
        var architectureMethod: Architecture.Method {
            switch self {
            case .Goto: return .goto
            case .Set: return .set
            case .Add: return .add
            case .Multiply: return .multiply
            case .SetRegister: return .setRegister
            case .AddRegister: return .addRegister
            case .MultiplyRegister: return .multiplyRegister
            case .Read: return .read
            case .Write: return .write
            }
        }
        
    }
    
}
