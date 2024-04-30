namespace BashHellScript;

internal static class Verbose
{
    public static void Log(object log)
    {
#if DEBUG
        Console.WriteLine(log);
#endif
    }
}
