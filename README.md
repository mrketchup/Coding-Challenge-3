# Coding-Challenge-3
This project produces an executable binary for use on the command line in Mac OS 10. The executable is used for both executing cc3 binaries and compiling cc3 source files into binaries.

## Building
There is a Makefile included to make building easier. Xcode 7.3+ with Swift 2.2+ is required to build the emulator/compiler. All output of the Makefile targets are in the `bin/` directory.
#### Makefile Usage
- `build` - Builds the emulator/compiler. The executable is named `cc3`
- `challenges` - Builds the cc3 binaries for all the coding challenge goals
- `clean` - Deletes the `bin/` directory

## Emulator/Compiler
After building, this file is output to `bin/cc3`. It is used to both execute cc3 binaries and compile cc3 source files into binaries.
#### Emulating/Executing
Specifying the `-e` or `--execute` flag (or no flag) followed by one or more cc3 binary files will execute the files. The files will be executed in the order they are passed.

``` bash
bin/cc3 Test1 Test2
```
or

``` bash
bin/cc3 -e Test1 Test2
```
or

``` bash
bin/cc3 --execute Test1 Test2
```
##### Important Note
While memory is reset between executions, registers are not. This can be useful for chaining executables.

#### Compiling
Specifying the `-c` or `--compile` flag followed by one or more `.cc3	` source files will compile the files. The binaries are outputed into the directory in which the compiler is ran. They are named after their source files sans file extension.

``` bash
bin/cc3 -c Test1.cc3 Test2.cc3
```
or

``` bash
bin/cc3 --compile Test1.cc3 Test2.cc3
```
You can even compile and execute all at once!

``` bash
bin/cc3 --compile Test.cc3 --execute Test
```

## CC3 Language Specification
Instruction | Method Syntax      | Info
------------|--------------------|-----
`000`       | `null`             | Inserts a zeroed out word
`100`       | `exit`             | Means halt
`2dn`       | `set d n`          | Set register `d` to `n` (between `0` and `9`)
`3dn`       | `add d n`          | Add `n` to register `d`
`4dn`       | `mult d n`         | Multiply register `d` by `n`
`5ds`       | `set_reg d s`      | Set register `d` to the value of register `s`
`6ds`       | `add_reg d s`      | Add the value of register `s` to register `d`
`7ds`       | `mult_reg d s`     | Multiply register `d` by the value of register `s`
`8da`       | `read d a`         | Set register `d` to the value in RAM whose address is in register `a`
`9sa`       | `write d a`        | Set the value in RAM whose address is in register `a` to that of register `s`
`0ds`       | `goto d s`         | Goto the location in register `d` unless register `s` contains `0`
`xyz`       | `raw xyz` or `xyz` | Use the raw value provided
N/A         | `#abc`             | Comment the code with `abc`. This can be on its own line or at the end of an executable line
