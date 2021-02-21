# Kira

A (killer) sudoku solver.

![](https://user-images.githubusercontent.com/33803413/108632939-b8790f00-7471-11eb-8e90-029ca1aadcb5.png)

## Requirements

* [Ruby](https://www.ruby-lang.org/en/)
* [colorize](https://github.com/fazibear/colorize)

## Usage

```
kira [options]
```

### Options

Option | Meaning
--- | ---
`-h`, `--help` | Show help message and exit.
`-V`, `--version` | Output version information and exit.
`--pretty[=<format>]` | Pretty-print the result in a given format, where `<format>` can be `ascii` or `box`. When `=<format>` is omitted, it defaults to `ascii`.
`--color` | Colorize the output.

### Input syntax

The `kira`'s input consists of an optional grid of cell values and any number
(including zero) of equations. The grid consists of values from 1 to 9 and dots
representing empty cells. If present, the grid should have a length of 81.
An equation consists of one or more 2-dimensional coordinates of cells,
separated by the `+` sign, followed by the `=` sign and an integer. Each
coordinate consists of zero-based row and column numbers separated by a comma
and surrounded with parentheses. Whitespace characters are generally ignored,
but each equation needs to be on its own line.

To finish entering the input, type <kbd>Ctrl-D</kbd> on GNU/Linux or
<kbd>Ctrl-Z</kbd> followed by <kbd>Enter</kbd> on Windows.

#### Example

```
64.......
7........
....7941.
.........
.........
21.......
4........
.........
......834
(2,0)+(3,0)+(3,1)=17
(1,1)+(2,1)=8
(0,2)+(0,3)+(1,2)+(1,3)+(1,4)=25
(2,2)+(2,3)=8
(0,4)+(0,5)+(1,5)=8
(0,6)+(0,7)+(0,8)=12
(1,6)+(1,7)=17
(1,8)+(2,8)=11
(4,0)+(4,1)=14
(3,2)+(4,2)+(5,2)=19
(3,3)+(3,4)+(3,5)+(3,6)=15
(4,3)+(4,4)=9
(5,3)+(5,4)+(5,5)+(5,6)=22
(4,5)+(4,6)=10
(3,7)+(3,8)+(4,7)+(4,8)+(5,7)+(5,8)=34
(7,0)+(8,0)+(8,1)=17
(6,1)+(7,1)=10
(6,2)+(6,3)=12
(7,2)+(7,3)+(7,4)+(8,2)+(8,3)=27
(6,4)+(6,5)+(6,6)+(6,7)=26
(7,5)+(8,4)+(8,5)=9
(7,6)+(7,7)=7
(6,8)+(7,8)=8
```

## License

[MIT](https://github.com/wadiim/kira/blob/master/LICENSE)
