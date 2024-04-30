using Antlr4.Runtime;

namespace BashHellScript.ScriptRunner.Runtime.HExceptions;

public class HException : Exception
{
    // Context of exception (line, error member, etc)
    public ParserRuleContext? Context { get; init; }

    public HException(string message)
        : base(message) { }

    public HException(string message, ParserRuleContext? context)
        : this(message) => Context = context;
}

public class HUnknownFunctionReferenceException : HException
{
    public HUnknownFunctionReferenceException(string functionName)
        : base($"Unknown function '{functionName}'") 
    { }
}