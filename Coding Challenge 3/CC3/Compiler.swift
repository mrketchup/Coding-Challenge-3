//
//  Compiler.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/12/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import Foundation

class Compiler {
    
    enum CompilerError: Error {
        case invalidFileData
        case invalidSyntax(line: Int)
        case unknownMethod(String, line: Int)
        case illegalArgument(String, line: Int)
    }
    
    let lines: [String]
    
    convenience init(filePath: String) throws {
        let codeString = try String(contentsOfFile: filePath, encoding: .utf8)
        self.init(codeString: codeString)
    }
    
    convenience init(fileData: Data) throws {
        guard let codeString = String(data: fileData, encoding: .utf8) else {
            throw CompilerError.invalidFileData
        }
        
        self.init(codeString: codeString)
    }
    
    init(codeString: String) {
        let rawLines = codeString.components(separatedBy: CharacterSet.newlines)
        lines = rawLines.map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
    }
    
    func compile() throws -> [Int] {
        var instructions: [Int] = []
        
        for lineNumber in 1...lines.count {
            let code = try stripComments(lineNumber, rawCode: lines[lineNumber - 1])
            
            guard !code.isEmpty else {
                continue // Comment or empty line
            }
            
            guard code != Language.SpecialMethod.Exit else {
                instructions.append(100)
                continue
            }
            
            guard code != Language.SpecialMethod.Null else {
                instructions.append(000)
                continue
            }
            
            if let instruction = try parseRaw(lineNumber, code: code) {
                instructions.append(instruction)
                continue
            }
            
            let (method, arg1, arg2) = try splitLine(lineNumber, code: code)
            let instruction = method.architectureMethod.rawValue * 100 + arg1 * 10 + arg2
            instructions.append(instruction)
        }
        
        return instructions
    }
    
    private func stripComments(_ line: Int, rawCode: String) throws -> String {
        let split = rawCode.components(separatedBy: Language.CommentSymbol)
        
        guard let code = split.first?.trimmingCharacters(in: CharacterSet.whitespaces) else {
            throw CompilerError.invalidSyntax(line: line)
        }
        
        return code
    }
    
    private func splitLine(_ line: Int, code: String) throws -> (Language.Method, Int, Int) {
        let parts = code.components(separatedBy: " ").filter { !$0.isEmpty }
        
        guard parts.count == 3 else {
            throw CompilerError.invalidSyntax(line: line)
        }
        
        guard let method = Language.Method(rawValue: parts[0]) else {
            throw CompilerError.unknownMethod(parts[0], line: line)
        }
        
        let (arg1, arg2) = try parseArgs(line, arg1String: parts[1], arg2String: parts[2])
        return (method, arg1, arg2)
    }
    
    private func parseArgs(_ line: Int, arg1String: String, arg2String: String) throws -> (Int, Int) {
        guard let arg1 = Int(arg1String), (0..<Architecture.DigitSize).contains(arg1) else {
            throw CompilerError.illegalArgument("\(arg1String)", line: line)
        }
        
        guard let arg2 = Int(arg2String), (0..<Architecture.DigitSize).contains(arg2) else {
            throw CompilerError.illegalArgument("\(arg2String)", line: line)
        }
        
        return (arg1, arg2)
    }
    
    private func parseRaw(_ line: Int, code: String) throws -> Int? {
        guard code.hasPrefix(Language.SpecialMethod.Raw) else {
            guard let rawCode = Int(code), (0..<Architecture.WordSize).contains(rawCode) else {
                return nil
            }
            
            return rawCode
        }
        
        let parts = code.components(separatedBy: " ").filter { !$0.isEmpty }
        guard parts.count == 2 else {
            throw CompilerError.invalidSyntax(line: line)
        }
        
        guard let rawCode = Int(parts[1]), (0..<Architecture.WordSize).contains(rawCode) else {
            throw CompilerError.illegalArgument("\(parts[1])", line: line)
        }
        
        return rawCode
    }
    
}
