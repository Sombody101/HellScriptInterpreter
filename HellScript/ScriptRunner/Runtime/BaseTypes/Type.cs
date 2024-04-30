namespace BashHellScript.ScriptRunner.Runtime.BaseTypes;

internal class HType : IEquatable<HType>
{
    public string Type { get; init; }
    public Type? TrueType { get; init; }

    public HType(string typeName, Type? trueType)
    { 
        Type = typeName;
        TrueType = trueType;
    }

    public override bool Equals(object? obj)
    {
        if (obj is null)
            return false;

        return Equals((HType)obj);
    }

    public bool Equals(HType? type)
    {
        if (type is null)
            return false;

        return Type == type.Type;
    }

    public override int GetHashCode()
        => Type.GetHashCode();
}
