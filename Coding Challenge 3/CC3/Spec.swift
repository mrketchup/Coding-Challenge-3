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
        case Goto = 0
        case Halt
        case Set
        case Add
        case Multiply
        case SetRegister
        case AddRegister
        case MultiplyRegister
        case Read
        case Write
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
            case .Goto: return .Goto
            case .Set: return .Set
            case .Add: return .Add
            case .Multiply: return .Multiply
            case .SetRegister: return .SetRegister
            case .AddRegister: return .AddRegister
            case .MultiplyRegister: return .MultiplyRegister
            case .Read: return .Read
            case .Write: return .Write
            }
        }
        
    }
    
}
