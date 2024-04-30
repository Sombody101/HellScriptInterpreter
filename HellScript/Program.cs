using BashHellScript.ScriptRunner;

namespace BashHellScript;

internal static class Program
{
    private static int Main(string[] args)
    {
#if DEBUG
        args = new string[] { "../../../tests/test.hs" };
#endif

        if (args.Length == 0)
        {
            Console.WriteLine("No arguments given.");
            Environment.Exit(0);
        }

        string file = args[0];

        ExitIfFailed(ScriptLoader.InitializeProject(file));
        var scriptExitStatus = ScriptLoader.StartProjectFromEntryFile(file);

        return (int)scriptExitStatus;
    }

    private static void ExitIfFailed(ExitStatus stat)
    {
        if (stat != ExitStatus.Success)
            Environment.Exit((int)stat);
    }
}
