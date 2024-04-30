namespace BashHellScript;

internal static class Utils
{
    private static readonly Random rnd = new();

    public static string GenerateRuntimeName(string prefix)
        => $"{prefix}`{rnd.Next()}";
}
