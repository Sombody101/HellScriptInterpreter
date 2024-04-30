namespace BashHellScript.ScriptRunner.Runtime.BaseTypes;

internal class HObject
{
    public HType ObjectType { get; protected set; }
    public string ObjectName { get; protected set; }

    public HObject(string objName, object? obj)
    {
        UpdateType(objName, obj);
    }

    /// <summary>
    /// Allows for the type of an HObject to be updated 
    /// without creating a new instance of the HObject
    /// </summary>
    /// <param name="objName"></param>
    /// <param name="obj"></param>
    protected void UpdateType(string objName, object? obj)
    {
        if (obj is not null)
        {
            ObjectType = new(objName, obj.GetType());
            return;
        }

        ObjectType = new(
            ObjectName ?? "null", // Try to preserve the object's name if available
            null
        );
    }
}
