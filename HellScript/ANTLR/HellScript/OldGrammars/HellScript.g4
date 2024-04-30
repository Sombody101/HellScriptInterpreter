// $antlr-format alignTrailingComments true, columnLimit 150, minEmptyLines 1 
// $antlr-format maxEmptyLinesToKeep 1, reflowComments false, useTab false
// $antlr-format allowShortRulesOnASingleLine false, allowShortBlocksOnASingleLine true
// $antlr-format alignSemicolons hanging, alignColons hanging

make this this is broken

parser grammar HellScript;

options {
    tokenVocab = HellScriptLexer;
}

program
    : sourceElements? EOF
    ;

sourceElement
    : statement eos
    ;

statement
    : block
    | variableStatement
    | importStatement
    | emptyStatement_
    // | classDeclaration
    | functionDeclaration
    | expression
    // | ifStatement
    // | iterationStatement
    // | continueStatement
    // | breakStatement
    | returnStatement
    | labelledStatement
    // | switchStatement
    // | throwStatement
    // | tryStatement
    ;

block
    : LBRACE statement* RBRACE
    ;

lineBlock
    : ARROW expression
    ;

statmentList
    : statement+
    ;

importStatement
    : importLib
    | importScript
    | deportStandardLib
    ;

importScript
    : IMPORT_SCRIPT STRING
    ;

importLib
    : IMPORT_LIB CHAINED_IDENTIFIER
    ;

deportStandardLib
    : DEPORT_LIB CHAINED_IDENTIFIER
    ;

functionDeclaration
    : CHAINED_IDENTIFIER IDENTIFIER '(' parameterList? ')' block
    ;

functionCall
    : CHAINED_IDENTIFIER '(' argumentList? ')'
    ;

variableStatement
    : variableDeclarationList eos
    ;

variableDeclarationList
    : varModifier variableDeclaration (',' variableDeclaration)*
    ;

variableDeclaration
    : IDENTIFIER ('=' expression)?
    ;

emptyStatement_
    : SEMI
    ;

varModifier
    : CONST (
        VAR                  // Var (guess type as runtime)
        | CHAINED_IDENTIFIER // Type name
    )
    ;

returnStatement
    : RETURN expression eos
    ;

labelledStatement
    : IDENTIFIER ':' statement
    ;

// Parameter list is not optional here, but needed for overloads to be recognized Invalid parameter
// count will be handled at runtime This can also only be used within a class context (once classes
// are set up)
// e.g. operator MyType +(var a, var b) { return a + b; }
// e.g. operator MyType ==(var a, var b) -> a == b;
operatorOverload
    : OPERATOR IDENTIFIER ANY_OPERATOR '(' parameterList? ')' block
    ;

arrayLiteral
    : ('[' elementList ']')
    ;

sourceElements
    : sourceElement+
    ;

elementList
    : ','* arrayElement? (','+ arrayElement)* ','*
    ;

arrayElement
    : expression
    ;

expressionSequence
    : expression (',' expression)*
    ;

expression
    : anonymousFunction  # FunctionExpression
    | CONSTANT           # constantExpression
    | CHAINED_IDENTIFIER # chainedIdentifierExpression
    | IDENTIFIER         # identifierExpression

    // Functions
    | functionCall                                    # functionCallExpression
    | IDENTIFIER ASSIGN expression                    # assignmentExpression
    | LPAREN expression RPAREN                        # parenthesizedExpression
    | expression QUESTION expression COLON expression # conditionalExpression

    // Math operations
    | expression ADD_OPERATOR expression    # additiveExpression
    | expression MULT_OPERATOR expression   # multiplicativeExpression
    | UNARY_OPERATOR expression             # unaryExpression
    | expression DOUBLE_OPERATOR            # doubleExpression
    | expression ASSIGN_OPERATOR expression # assignExpression
    | LPAREN IDENTIFIER RPAREN expression   # typeCastExpression
    | arrayLiteral                          # ArrayLiteralExpression
    ;

assignable
    : IDENTIFIER
    | arrayLiteral
    ;

// Same as a function, but without an identifier (name)
// e.g. function getSomething() { }
// e.g. int main() -> getSomething();
anonymousFunction
    : functionDeclaration                                          # NamedFunction
    | (FUNC_DECLARATION | IDENTIFIER) '(' parameterList? ')' block # AnonymousFunctionDec
    ;

parameterList
    : VAR_DECLARATION (',' VAR_DECLARATION)*
    ;

argumentList
    : expression (',' expression)*
    ;

/* end Functions */

compoundDeclaration
    : VAR_DECLARATION ASSIGN expression
    ;

eos
    : SEMI
    | EOF
    ;