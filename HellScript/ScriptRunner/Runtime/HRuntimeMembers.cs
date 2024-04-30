using BashHellScript.ScriptRunner.Runtime.BaseTypes;
using BashHellScript.ScriptRunner.Runtime.HExceptions;
using System.Runtime.InteropServices;

namespace BashHellScript.ScriptRunner.Runtime;

// Non-nullable field must contain a non-null value when exiting constructor. Consider declaring as nullable.
#pragma warning disable CS8618

internal static class HRuntimeMembers
{
    #region Script Information
    
    public static string ScriptVersion { get; set; } = string.Empty;
    public static string ProjectDirectory { get; set; } = string.Empty;
    public static readonly List<string> ImportedScripts = new();

    public static string? EntryFile => ImportedScripts.FirstOrDefault();

    #endregion // Script Information

    #region Script Members

    public static Stack<CallStackContext> StackContexts { get; private set; }

    /// <summary>
    /// Get the most recent context, or <see langword="null"/> (only if something wrong has happened)
    /// </summary>
    public static CallStackContext? CurrentContext { get => StackContexts.LastOrDefault(); }

    /// <summary>
    /// Create a new context and push it onto the stack
    /// </summary>
    /// <param name="arguments"></param>
    public static void PushContext([Optional] CallStackContext.ArgumentInfo[] arguments)
    {
        // If arguments is null, then there are just no args to load.
        StackContexts.Push(new(arguments ?? Array.Empty<CallStackContext.ArgumentInfo>()));
    }

    /// <summary>
    /// Remove the most recent context from the <see cref="StackContexts"/>
    /// </summary>
    public static void PopContext()
    {
        if (StackContexts.Count - 1 == 0)
        {
            throw new InvalidOperationException("Attempted to remove global stack context");
        }

        StackContexts.Pop();
    }

    /// <summary>
    /// Adds a function to the current context onto the <see cref="StackContexts"/>
    /// </summary>
    /// <param name="function"></param>
    public static void AddFunctionToContext(HFunction function)
    {
        // Get current context
        var ctx = CurrentContext;
        if (ctx is null)
        {
            Console.WriteLine($"The stack is empty: Cannot add function '{function.ObjectName}'");
            Environment.Exit((int)ExitStatus.EmptyStack);
        }

        ctx.DefinedObjects.Add(function);
    }

    /// <summary>
    /// Get a defined function for the current context on the <see cref="StackContexts"/>
    /// </summary>
    /// <param name="functionName"></param>
    /// <returns></returns>
    /// <exception cref="HUnknownFunctionReferenceException"></exception>
    public static HFunction GetFunctionFromContext(string functionName)
    {
        // Get current context
        var ctx = CurrentContext;
        if (ctx is null)
        {
            Console.WriteLine($"The stack is empty: Cannot locate function '{functionName}'");
            Environment.Exit((int)ExitStatus.EmptyStack);
        }

        var found = ctx.DefinedObjects.Where(item => item is HFunction).First(func => func.ObjectName == functionName)
            ?? throw new HUnknownFunctionReferenceException(functionName);

        return (HFunction)found;
    }

    #endregion // Script Members

    #region Lexer and Parser
    public static HellScriptLexer HLexer { get; set; }
    public static HellScriptParser HParser { get; set; }
    #endregion // Lexer and Parser

    /// <summary>
    /// Initialize the <see cref="StackContexts"/>
    /// </summary>
    public static void Initialize()
    {
        // Create the stack
        StackContexts = new();

        // Push the global scope onto the stack.
        // This stack context should not be removed, because everything is defined inside it.
        PushContext();
    }
}
