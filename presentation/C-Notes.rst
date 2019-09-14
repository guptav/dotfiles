Style grading checklist
========================

http://www.cs.yale.edu/homes/aspnes/classes/223/notes.html#programmingStyle

Score is 20 points minus 1 for each box checked (but never less than 0)


Comments

[ ] Undocumented module.
[ ] Undocumented function other than main.
[ ] Underdocumented function: return value or args not described.
[ ] Undocumented program input and output (when main is provided).
[ ] Undocumented struct or union components.
[ ] Undocumented #define.
[ ] Failure to cite code taken from other sources.
[ ] Insufficient comments.
[ ] Excessive comments.

Naming

[ ] Meaningless function name.
[ ] Confusing variable name.
[ ] Inconsistent variable naming style (UgLyName, ugly_name, NAME___UGLY_1).
[ ] Inconsistent use of capitalization to distinguish constants.

Whitespace

[ ] Inconsistent or misleading indentation.
[ ] Spaces not used or used misleadingly to break up complicated expressions.
[ ] Blank lines not used or used misleadingly to break up long function bodies.

Macros

[ ] Non-trivial constant with no symbolic name.
[ ] Failure to parenthesize expression in macro definition.
[ ] Dependent constant not written as expression of earlier constant.
[ ] Underdocumented parameterized macro.

Global variables

[ ] Inappropriate use of a global variable.

Functions

[ ] Kitchen-sink function that performs multiple unrelated tasks.
[ ] Non-void function that returns no useful value.
[ ] Function with too many arguments.

Code organization

[ ] Lack of modularity.
[ ] Function used in multiple source files but not declared in header file.
[ ] Internal-use-only function not declared static.
[ ] Full struct definition in header files when components should be hidden.
[ ] #include "file.c"
[ ] Substantial repetition of code.

Miscellaneous

[ ] Other obstacle to readability not mentioned above.
