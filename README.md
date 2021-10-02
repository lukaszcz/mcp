MCP is a simple macro processor. It performs basic text substitution
and rudimentary conditional evaluation.

Requirements
------------
* C compiler
* make

Usage
-----
* Compilation: `make`
* Invocation: `mcp [options] [input_files]`

MCP processes simple macros in input files or from standard input.
Writes output from an input file to an output file with the same name,
but with `.out` appended. If reading from standard input then writes
to standard output. If an input file has the `.mcp` extension then the
name of the output file is the name of the input file without `.mcp`.

You may pass `-` instead of an input file to indicate standard input.

Commands
--------

There is a distinction between macros and defines, which is that
defines are evaluated when defined and macros when called. Macro
definitions are lexically scoped. See the `&define`, `&local-define`,
`&macro` and `&local-macro` commands.

All commands are prefixed with `&`. This character may be changed with
the `&set-macro-char` command. Macros and defines are referenced by
`&name&` where `name` is the name of the macro or define to be
expanded. The closing `&` may be omitted if the next character is a
whitespace. In case of commands requiring arguments (like `&define` or
`&include`) the whole command with its arguments must be placed on one
line.

```
&&
```

Quotes `&`, expands to one `&`.

```
&#
```

Starts a comment, which extends to the end of the current line. Macro
substitution is not performed in comments. Comments are not included
in the output.

```
&<text>
```

Quotes text.

```
&\n
```

Quotes a newline. (`\n` above stands for a real newline).

```
&clear-defines
```

Undefines all local defines (but not macros).

```
&clear-macros
```

Undefines all local macros (but not defines).

```
&define name
&define name text
```

Defines a define named `name` which expands to `text`. If `text` is
omitted then it is assumed to be the empty string. The name of a
define cannot begin with the "macro character". The scope of the
definition is the top-level file currently beign parsed and all files
included from the top-level file.

```
&local-define name
&local-define name text
```

The same as `&define`, but defines the define locally, i.e. only in
the current macro.

```
&expand-non-prefix-on
&expand-non-prefix-off
```

Turns non-prefix expansion on/off. If it's on, then macros/defines are
expanded even if not prefixed. The commands, however, must still be
prefixed.

```
&if <expression>
   [block1]
&elseif <expr2>
   ...
&else
   [block2]
&endif
```

Outputs `[block1]` if `<expression>` is true (non-null, see `&NULL`),
otherwise `[block2]`. The block is subject to text/macro
expansion. Expressions may use defines prefixed with `&` and bare
text strings.

Allowed operators:
* `=`, `<=`, `>=`: string comparisions
* `||`, `&&`: disjunction and conjunction
* `!`: negation
* `defined name`: true if `name` is defined
* `(`, `)`: grouping

```
&ifdef name
&ifndef name
```

The same as above, but checks whether `name` is defined/undefined.

```
&include filename
```

Includes the file `filename`. The inclusion is treated like calling a
macro (with respect to local/global scope; see `&local-define`).

```
&macro name
  ...
&endm
```

Defines a global macro. The difference between a macro and a define is
that defines are evaluated when defined and macros when called. Macros
may take arguments, e.g., `&my_macro(arg1, arg2)`. Arguments are
accesible via `&argN`, where `N` is the argument number. The number of
arguments passed is accessible via `&arg0`.

```
&local-macro name
  ...
&endm
```

Defines a local macro. See `&local-define`.

```
&NULL
```

Expands to nothing. Sometimes useful in expressions.

```
&set-macro-char char
```

Sets the "macro character" to `char` instead of the default `&`. This
should be called only once before processing any other commands
(otherwise problems might occur).

```
&undefine name
```

Undefines the macro/define named `name` if it is defined, otherwise
does nothing.

Options
-------

```
-dDEFINE
-dDEFINE=VALUE
--define DEFINE
--define DEFINE=VALUE
```

Defines `DEFINE` globally, for all input files. See the `&define`
command.

```
-n
--non-prefixed
```

Turn on non-prefixed expansion. See the `&expand-non-prefixed-on`
command.

```
-i
--ignore-case
```

Makes MCP case-insensitive. By default it is case-sensitive.

```
-h
--help
```

Prints a help message and exits.

```
-v
--version
```

Print MCP version and exits.

```
--
```

Indicates the end of options.

Copyright and license
---------------------

Copyright (C) 2006-2021 by Lukasz Czajka.

Distributed under the terms of GPL 2. See [LICENSE](LICENSE).

Contains BSD-licensed hashtable code by Christopher Clark. See the
[hashtable](hashtable) directory.
