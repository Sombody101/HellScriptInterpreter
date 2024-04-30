using BashHellScript.ScriptRunner.Runtime.BaseTypes;

namespace BashHellScript.ScriptRunner.Runtime.Structures;

internal class HClass : HObject
{
    private readonly List<HObject> definedMembers;

    public List<HObject> DefinedMembers { get => definedMembers; }

    public HClass(HType classType)
        : this(classType, new()) { }

    public HClass(HType classType, List<HObject> members)
        : base(classType.Type, null)
    {
        ObjectType = classType;
        definedMembers = members;
    }

    public void AddClassMember(HObject member)
        => definedMembers.Add(member);

    /// <summary>
    /// Gets a function from the class instance if defined
    /// </summary>
    /// <param name="name"></param>
    /// <returns></returns>
    public HFunction? TryGetPublicFunction(string name)
    {
        var result = definedMembers.Find(obj =>
            obj is HFunction func && func.ObjectName == name
        );

        return result as HFunction;
    }

    /// <summary>
    /// Gets any object by name from the class instance if defined
    /// </summary>
    /// <param name="name"></param>
    /// <returns></returns>
    public HObject? TryGetDefinedObject(string name) 
        => definedMembers.Find(obj => obj.ObjectName == name);
}
