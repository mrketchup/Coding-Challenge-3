//
//  Challenge_Tests.swift
//  Coding Challenge 3
//
//  Created by Matt Jones on 5/24/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import XCTest

class ChallengeTests: XCTestCase {

    let bundle = NSBundle(forClass: ChallengeTests.classForCoder())
    
    func testCodingChallenge() {
        do {
            let path = bundle.pathForResource("Challenge", ofType: "cc3")!
            let compiler = try Compiler(filePath: path)
            let instructions = try compiler.compile()
            let emulator = Emulator()
            let executions = try emulator.execute(instructions)
            XCTAssertEqual(executions, 16)
            XCTAssertEqual(emulator.registers, [0, 0, 0, 0, 0, 0, 0, 9, 0, 999])
        } catch {
            XCTFail("\(error)")
        }
    }

}
