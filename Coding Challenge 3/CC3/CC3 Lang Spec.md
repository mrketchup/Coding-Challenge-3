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
