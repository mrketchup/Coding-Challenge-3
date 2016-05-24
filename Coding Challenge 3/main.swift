//
//  main.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/12/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import Foundation

enum Error: ErrorType {
    case FileNotFound
}

let legalArguments = ["-e", "--execute", "-c", "--compile"]
let dir = NSFileManager.defaultManager().currentDirectoryPath

var arguments: [String: [String]] = [:]
var currentArgument = "_"

for index in 1..<Process.arguments.count {
    let argument = Process.arguments[index]
    
    if argument.hasPrefix("-") || argument.hasPrefix("--") {
        guard legalArguments.contains(argument) else {
            print("Illegal argument: \(argument)")
            exit(1)
        }
        
        currentArgument = argument
    } else {
        if arguments[currentArgument] == nil {
            arguments[currentArgument] = []
        }
        
        arguments[currentArgument]?.append(argument)
    }
}

for arg in arguments.keys {
    var values = arguments[arg]
    values = values?.map { filename in
        guard !filename.hasPrefix("/") else {
            return filename
        }
        
        return "\(dir)/\(filename)"
    }
    
    arguments[arg] = values
}

let compileFiles = (arguments["-c"] ?? []) + (arguments["--compile"] ?? [])
let executeFiles = (arguments["-e"] ?? []) + (arguments["--execute"] ?? []) + (arguments["_"] ?? [])

do {
    for filePath in compileFiles {
        let fileName = (filePath as NSString).lastPathComponent
        let binName = (fileName as NSString).stringByDeletingPathExtension
        let binPath = "\(dir)/\(binName)"
        print("Compiling '\(fileName)' into '\(binName)'...")
        
        let compiler = try Compiler(filePath: filePath)
        let instructions = try compiler.compile()
        let data = try BinaryWriter().encode(instructions: instructions)
        data.writeToFile(binPath, atomically: true)
    }
    
    if compileFiles.count > 0 {
        print("Done. Compiled \(compileFiles.count) file(s).")
    }
} catch {
    print(error)
    exit(1)
}

do {
    let emulator = Emulator()
    
    for filePath in executeFiles {
        let fileName = (filePath as NSString).lastPathComponent
        print("Executing '\(fileName)'...")
        
        guard let data = NSData(contentsOfFile: filePath) else {
            throw Error.FileNotFound
        }
        
        let instructions = try BinaryReader().decode(data: data)
        let executions = try emulator.execute(instructions)
        print("Registers: \(emulator.registers.map({ String(format: "%03d", $0) }))")
        print("Executions: \(executions)")
    }
} catch {
    print(error)
    exit(1)
}
