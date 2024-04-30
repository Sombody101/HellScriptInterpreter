using BashHellScript.ScriptRunner.Runtime.BaseTypes;

namespace BashHellScript.ScriptRunner.Runtime;

/// <summary>
/// Provides isolation context for a function or method call
/// </summary>
internal class CallStackContext
{
    public ArgumentInfo[] Arguments { get; init; }
    public List<HObject> DefinedObjects { get; init; } = new();
    public Stack<ScopedStackContext> Scopes { get; init; } = new();

    public CallStackContext(ArgumentInfo[] arguments)
    {
        Arguments = arguments;
    }

    public readonly struct ArgumentInfo
    {
        public Type ArgumentType { get; init; }
        public object Argument { get; init; }
    }
}

/// <summary>
/// Provides isolation context for a scoped operation (if, for, block, etc)
/// </summary>
internal class ScopedStackContext
{
    public List<HObject> DefinedObjects { get; init; } = new();
}