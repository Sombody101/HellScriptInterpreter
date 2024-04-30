using Antlr4.Runtime.Misc;
using BashHellScript.ScriptRunner.Runtime.BaseTypes;

namespace BashHellScript.ScriptRunner.Runtime;

internal class HRuntime : HellScriptParserBaseVisitor<object?>
{
    public override object? VisitStatementList([NotNull] HellScriptParser.StatementListContext context)
    {
        var statements = context.statement();

        if (statements is null || statements.Length == 0)
        {
            // No statements; nothing to return
            return null;
        }

        foreach (var statement in statements)
        {
            if (statement.returnStatement() is { } returnStatement)
            {
                // Visit the expression within the return statement, even if there's more code in the block
                return Visit(returnStatement);
            }

            Visit(statement);
        }

        // No return statements encountered; just return null
        return null;
    }

    #region Statement Items

    public override object? VisitBlock([NotNull] HellScriptParser.BlockContext context)
    {
        // e.g. void myFunction() -> someStatement()
        // Execute 'someStatement()' and return its value
        if (context.arrowBlock() is { } arrowBlock)
        {
            // Visit and return the output from the statement
            return Visit(arrowBlock.statement());
        }

        // e.g. void myFunction() { statements }
        // Visit and return the output from the list of statements
        return Visit(context.statementList());
    }

    /// <summary>
    /// Adds a new <see cref="HFunction"/> instance to the newest <see cref="CallStackContext"/> in <see cref="HRuntimeMembers"/>
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    public override object? VisitFunctionDeclaration([NotNull] HellScriptParser.FunctionDeclarationContext context)
    {
        var func = new HFunction(context);
        HRuntimeMembers.AddFunctionToContext(func);

        // Return null because functions should not be defined AND assigned to a variable in same statement
        return null;
    }

    #region Expressions

    /// <summary>
    /// Creates a nameless <see cref="HFunction"/> and returns it (to be used as a variable or parameter)
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    public override object VisitAnonymousFunctionDecl([NotNull] HellScriptParser.AnonymousFunctionDeclContext context)
    {
        return new HFunction(context);
    }

    #endregion // Expressions

    #endregion // Stack Items
}
