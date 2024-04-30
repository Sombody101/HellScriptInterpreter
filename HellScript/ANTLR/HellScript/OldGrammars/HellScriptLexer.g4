// $antlr-format alignTrailingComments true, columnLimit 150, minEmptyLines 1 
// $antlr-format maxEmptyLinesToKeep 1, reflowComments false, useTab false
// $antlr-format allowShortRulesOnASingleLine false, allowShortBlocksOnASingleLine true
// $antlr-format alignSemicolons hanging, alignColons hanging

lexer grammar HellScriptLexer;

// Keywords
VAR
    : 'var'
    ;

CONST
    : 'const'
    ;

DEPORT_LIB
    : '#deport'
    ;

IMPORT_LIB
    : '#use'
    ;

IMPORT_SCRIPT
    : '#import'
    ;

/* Operators */
ANY_OPERATOR
    : ADD_OPERATOR
    | MULT_OPERATOR
    | UNARY_OPERATOR
    | DOUBLE_OPERATOR
    | ASSIGN_OPERATOR
    | BOOL_OPERATOR
    | COMPARE_OPERATOR
    ;

ADD_OPERATOR
    : '+'
    | '-'
    ;

MULT_OPERATOR
    : '*'
    | '/'
    | '%'
    | '**'
    ;

UNARY_OPERATOR
    : '-'
    | '+'
    | '~'
    | '!'
    ;

DOUBLE_OPERATOR
    : '--'
    | '++'
    ;

ASSIGN_OPERATOR
    : '+='
    | '-='
    | '*='
    | '/='
    ;

BOOL_OPERATOR
    : AND
    | OR
    | XOR
    ;

COMPARE_OPERATOR
    : ':!='
    | ':=='
    | '=='
    | '!='
    | '>'
    | '<'
    | '>='
    | '<='
    ;

AND
    : '&&'
    | 'and'
    ;

OR
    : '||'
    | 'or'
    ;

XOR
    : '^'
    | 'xor'
    ;

ASSIGN
    : '='
    ;

DQUOTE
    : '"'
    ;

/* end Operators */

/* Identifiers */
// Can also be the same as an IDENTIFIER, so should come before
CHAINED_IDENTIFIER
    : IDENTIFIER ('.' IDENTIFIER)*
    ;

IDENTIFIER
    : [a-zA-Z_][a-zA-Z0-9_]*
    | [a-zA-Z_]
    ;

/* end Identifiers */

/* Constants */
CONSTANT
    : NUMBER
    | CHAR
    | BOOL
    | STRING
    ;

NUMBER
    : B1
    | B10
    | B16
    ;

CHAR
    : '\'' . '\''
    ;

BOOL
    : 'true'
    | 'false'
    ;

TEXT
    : ~[\\"]+
    ;

STRING
    : DQUOTE TEXT DQUOTE
    ;

WS
    : [\t\u000B\u000C\u0020\u00A0]+ -> channel(HIDDEN)
    ;

NL
    : [\r\n\u2028\u2029] -> channel(HIDDEN)
    ;

//  No concatenation, only interpolation
INTERP_STRING
    : '$"' TEXT DQUOTE
    ;

/* end Constants */

/* Types TYPE: 'byte' | 'short' | 'int' | 'long' | 'mint' // m(ega)int (Int128) // Unsigned (ish) |
 'sbyte' | 'ushort' | 'uint' | 'ulong' | 'umint' // unsigned m(ega)int // fpns | 'float' | 'double'
 | 'decimal' // Other | 'null'; end Types
 */

/* Integer types */
B1
    : ('0b' | '0B') [0-1_]+
    ;

B10
    : [0-9_]+
    ;

B16
    : ('0x' | '0X') [a-fA-F0-9_]+
    ;

/* end Integer types */

/* Keywords */
FUNC_DECLARATION
    : 'fn'
    | 'fun'
    | 'function'
    ;

RETURN
    : 'return'
    ;

OPERATOR
    : 'operator'
    ;

/* end Keywords */

/* Separators */
LPAREN
    : '('
    ;

RPAREN
    : ')'
    ;

LBRACE
    : '{'
    ;

RBRACE
    : '}'
    ;

LBRACK
    : '['
    ;

RBRACK
    : ']'
    ;

SEMI
    : ';'
    ;

COMMA
    : ','
    ;

DOT
    : '.'
    ;

QUESTION
    : '?'
    ;

COLON
    : ':'
    ;

ARROW
    : '->'
    ;

/* end Separators */

BlockComment
    : '/*' .*? '*/' -> skip
    ;

LineComment
    : '//' ~[\r\n]* -> skip
    ;