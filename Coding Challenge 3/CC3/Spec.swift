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
