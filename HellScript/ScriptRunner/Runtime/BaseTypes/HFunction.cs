namespace BashHellScript.ScriptRunner.Runtime.BaseTypes;

internal class HFunction : HObject
{
    private HellScriptParser.FunctionBodyContext functionBody;
    private HellScriptParser.FormalParameterListContext parameterList;

    public bool IsPublic { get; private set; }
    public string ReturnType { get; private set; }

    public HFunction(HellScriptParser.FunctionDeclarationContext function)
        : base(function.identifier().GetText(), typeof(HFunction))
    {
        // Could be a runtime defined method if no body (typeof, delete, etc)
        functionBody = function.functionBody();
        
        // Function input parameters
        parameterList = function.formalParameterList();

        // Get the name of the return type (might work on better system than just the raw-string name of the type)
        ReturnType = function.typeName().GetText();
    }

    public HFunction(HellScriptParser.AnonymousFunctionDeclContext aFunction)
        : base(Utils.GenerateRuntimeName("anonymous-function"), typeof(HFunction))
    {
        functionBody = aFunction.functionBody();

        // anonymous function input parameters
        parameterList = aFunction.formalParameterList();

        // Get the name of the return type (might work on better system than just the raw-string name of the type)
        ReturnType = aFunction.typeName().GetText();
    }

    public object? Invoke(object?[] parameters)
    {
        throw new NotImplementedException("uh oh (don't call functions pls)");
    }
}
