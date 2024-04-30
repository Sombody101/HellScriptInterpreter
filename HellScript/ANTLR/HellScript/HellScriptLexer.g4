// $antlr-format alignTrailingComments true, columnLimit 150, minEmptyLines 1
// $antlr-format maxEmptyLinesToKeep 1, reflowComments false, useTab false
// $antlr-format allowShortRulesOnASingleLine false, allowShortBlocksOnASingleLine true
// $antlr-format alignSemicolons hanging, alignColons hanging

lexer grammar HellScriptLexer;

channels {
    ERROR
}

options {
    superClass = HellScriptLexerBase;
}

RuntimeVersion
    : '#version'
    ;
    
ImportScript
    : '#import'
    ;

ImportLibrary
    : '#use'
    ;


HashBangLine
    : { this.IsStartOfFile() }? '#!' ~[\r\n\u2028\u2029]*
    ; // only allowed at start

MultiLineComment
    : '/*' .*? '*/' -> channel(HIDDEN)
    ;

SingleLineComment
    : '//' ~[\r\n\u2028\u2029]* -> channel(HIDDEN)
    ;

OpenBracket
    : '['
    ;

CloseBracket
    : ']'
    ;

OpenParen
    : '('
    ;

CloseParen
    : ')'
    ;

OpenBrace
    : '{' {this.ProcessOpenBrace();}
    ;

TemplateCloseBrace
    : {this.IsInTemplateString()}? '}' -> popMode
    ;

CloseBrace
    : '}' {this.ProcessCloseBrace();}
    ;

SemiColon
    : ';'
    ;

Comma
    : ','
    ;

Assign
    : '='
    ;

QuestionMark
    : '?'
    ;

Colon
    : ':'
    ;

Dot
    : '.'
    ;

PlusPlus
    : '++'
    ;

MinusMinus
    : '--'
    ;

Plus
    : '+'
    ;

Minus
    : '-'
    ;

BitNot
    : '~'
    ;

Not
    : '!'
    ;

Multiply
    : '*'
    ;

Divide
    : '/'
    ;

Modulus
    : '%'
    ;

Power
    : '**'
    ;

NullCoalesce
    : '??'
    ;

Hashtag
    : '#'
    ;

RightShiftArithmetic
    : '>>'
    ;

LeftShiftArithmetic
    : '<<'
    ;

LessThan
    : '<'
    ;

MoreThan
    : '>'
    ;

LessThanEquals
    : '<='
    ;

GreaterThanEquals
    : '>='
    ;

Equals_
    : '=='
    ;

NotEquals
    : '!='
    ;

IdentityEquals
    : ':=='
    ;

IdentityNotEquals
    : ':!='
    ;

BitAnd
    : '&'
    ;

BitXOr
    : '^'
    ;

BitOr
    : '|'
    ;

And
    : '&&'
    | 'and'
    ;

Or
    : '||'
    | 'or'
    ;

MultiplyAssign
    : '*='
    ;

DivideAssign
    : '/='
    ;

ModulusAssign
    : '%='
    ;

PlusAssign
    : '+='
    ;

MinusAssign
    : '-='
    ;

LeftShiftArithmeticAssign
    : '<<='
    ;

RightShiftArithmeticAssign
    : '>>='
    ;

BitAndAssign
    : '&='
    ;

BitXorAssign
    : '^='
    ;

BitOrAssign
    : '|='
    ;

PowerAssign
    : '**='
    ;

NullishCoalescingAssign
    : '??='
    ;

Arrow
    : '->'
    ;

/// Null Literals

NullLiteral
    : 'null'
    ;

/// Boolean Literals

BooleanLiteral
    : 'true'
    | 'false'
    ;

/// Numeric Literals

DecimalLiteral
    : DecimalIntegerLiteral '.' [0-9] [0-9_]* ExponentPart?
    | '.' [0-9] [0-9_]* ExponentPart?
    | DecimalIntegerLiteral ExponentPart?
    ;

/// Numeric Literals

HexIntegerLiteral
    : '0' [xX] [0-9a-fA-F] HexDigit*
    ;

OctalIntegerLiteral
    : '0' [0-7]+ {!this.IsStrictMode()}?
    ;

OctalIntegerLiteral2
    : '0' [oO] [0-7] [_0-7]*
    ;

BinaryIntegerLiteral
    : '0' [bB] [01] [_01]*
    ;

BigHexIntegerLiteral
    : '0' [xX] [0-9a-fA-F] HexDigit* 'n'
    ;

BigOctalIntegerLiteral
    : '0' [oO] [0-7] [_0-7]* 'n'
    ;

BigBinaryIntegerLiteral
    : '0' [bB] [01] [_01]* 'n'
    ;

BigDecimalIntegerLiteral
    : DecimalIntegerLiteral 'n'
    ;

/// Keywords

Break
    : 'break'
    ;

Do
    : 'do'
    ;

Typeof
    : 'typeof'
    ;

Case
    : 'case'
    ;

Else
    : 'else'
    ;

New
    : 'new'
    ;

Var
    : 'var'
    ;

Catch
    : 'catch'
    ;

Finally
    : 'finally'
    ;

Return
    : 'return'
    ;

Void
    : 'void'
    ;

Continue
    : 'continue'
    ;

For
    : 'for'
    ;

Switch
    : 'switch'
    ;

While
    : 'while'
    ;

Function_
    : 'function'
    ;

This
    : 'this'
    ;

With
    : 'with'
    ;

Default
    : 'default'
    ;

If
    : 'if'
    ;

Throw
    : 'throw'
    ;

Delete
    : 'delete'
    ;

In
    : 'in'
    ;

Try
    : 'try'
    ;

As
    : 'as'
    ;

Class
    : 'class'
    ;

Get
    : 'get'
    ;

Set
    : 'set'
    ;

Enum
    : 'enum'
    ;

Extends
    : Colon
    ;

Const
    : 'const'
    ;

Params
    : 'params'
    ;

/// The following tokens are also considered to be FutureReservedWords
/// when parsing strict mode

Private
    : 'private' {this.IsStrictMode()}?
    ;

Public
    : 'public' {this.IsStrictMode()}?
    ;

Interface
    : 'interface' {this.IsStrictMode()}?
    ;

Protected
    : 'protected' {this.IsStrictMode()}?
    ;

Static
    : 'static' {this.IsStrictMode()}?
    ;

/// Identifier Names and Identifiers

Identifier
    : IdentifierStart IdentifierPart*
    ;

/// String Literals
StringLiteral
    : ('"' DoubleStringCharacter* '"' | '\'' SingleStringCharacter* '\'') {this.ProcessStringLiteral();}
    ;

BackTick
    : '`' {this.IncreaseTemplateDepth();} -> pushMode(TEMPLATE)
    ;

WhiteSpaces
    : [\t\u000B\u000C\u0020\u00A0]+ -> channel(HIDDEN)
    ;

LineTerminator
    : [\r\n\u2028\u2029] -> channel(HIDDEN)
    ;

UnexpectedCharacter
    : . -> channel(ERROR)
    ;

mode TEMPLATE;

BackTickInside
    : '`' {this.DecreaseTemplateDepth();} -> type(BackTick), popMode
    ;

TemplateStringStartExpression
    : '${' -> pushMode(DEFAULT_MODE)
    ;

TemplateStringAtom
    : ~[`]
    ;

/* Fragments */

fragment DoubleStringCharacter
    : ~["\\\r\n]
    | '\\' EscapeSequence
    | LineContinuation
    ;

fragment SingleStringCharacter
    : ~['\\\r\n]
    | '\\' EscapeSequence
    | LineContinuation
    ;

fragment EscapeSequence
    : CharacterEscapeSequence
    | '0' // no digit ahead! TODO
    | HexEscapeSequence
    | UnicodeEscapeSequence
    | ExtendedUnicodeEscapeSequence
    ;

fragment CharacterEscapeSequence
    : SingleEscapeCharacter
    | NonEscapeCharacter
    ;

fragment HexEscapeSequence
    : 'x' HexDigit HexDigit
    ;

fragment UnicodeEscapeSequence
    : 'u' HexDigit HexDigit HexDigit HexDigit
    | 'u' '{' HexDigit HexDigit+ '}'
    ;

fragment ExtendedUnicodeEscapeSequence
    : 'u' '{' HexDigit+ '}'
    ;

fragment SingleEscapeCharacter
    : ['"\\bfnrtv]
    ;

fragment NonEscapeCharacter
    : ~['"\\bfnrtv0-9xu\r\n]
    ;

fragment EscapeCharacter
    : SingleEscapeCharacter
    | [0-9]
    | [xu]
    ;

fragment LineContinuation
    : '\\' [\r\n\u2028\u2029]+
    ;

fragment HexDigit
    : [_0-9a-fA-F]
    ;

fragment DecimalIntegerLiteral
    : '0'
    | [1-9] [0-9_]*
    ;

fragment ExponentPart
    : [eE] [+-]? [0-9_]+
    ;

fragment IdentifierPart
    : IdentifierStart
    | [\p{Mn}]
    | [\p{Nd}]
    | [\p{Pc}]
    | '\u200C'
    | '\u200D'
    ;

fragment IdentifierStart
    : [\p{L}]
    | [$_]
    | '\\' UnicodeEscapeSequence
    ;

// fragment RegularExpressionFirstChar
//     : ~[*\r\n\u2028\u2029\\/[]
//     | RegularExpressionBackslashSequence
//     | '[' RegularExpressionClassChar* ']'
//     ;
// 
// fragment RegularExpressionChar
//     : ~[\r\n\u2028\u2029\\/[]
//     | RegularExpressionBackslashSequence
//     | '[' RegularExpressionClassChar* ']'
//     ;
// 
// fragment RegularExpressionClassChar
//     : ~[\r\n\u2028\u2029\]\\]
//     | RegularExpressionBackslashSequence
//     ;
// 
// fragment RegularExpressionBackslashSequence
//     : '\\' ~[\r\n\u2028\u2029]
//     ;