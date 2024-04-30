using Antlr4.Runtime;
using BashHellScript.ScriptRunner.Runtime.HExceptions;
using System.Text;

namespace BashHellScript.ScriptRunner.Helpers;

internal static class Helpers
{
    /// <summary>
    /// Get a stack trace from a <see cref="ParserRuleContext"/>
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    public static string GetStack(this ParserRuleContext context)
    {
        var stack = new StringBuilder();

        stack.Append("");

        return stack.ToString();
    }

    /// <summary>
    /// Get a stack trace string from an <see cref="HException"/>
    /// </summary>
    /// <param name="ex"></param>
    /// <returns></returns>
    public static string GetStack(this HException ex)
        => $"{ex.GetBaseException().GetType().Name}: {GetStack(ex.Context!)}";
}
