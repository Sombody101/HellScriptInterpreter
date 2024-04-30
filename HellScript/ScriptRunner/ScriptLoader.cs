using Antlr4.Runtime;
using BashHellScript.ScriptRunner.Runtime;
using Newtonsoft.Json;
using Newtonsoft.Json.Bson;
using System.Diagnostics;

namespace BashHellScript.ScriptRunner;

internal static class ScriptLoader
{
    /// <summary>
    /// Provides a soft initialization to <see cref="HRuntimeMembers"/> (only script location information)
    /// </summary>
    /// <param name="entryFile"></param>
    /// <returns></returns>
    public static ExitStatus InitializeProject(string entryFile)
    {
        if (Directory.Exists(entryFile))
        {
            Console.WriteLine($"The path '{entryFile}' leads to a directory, not a file.");
            return ExitStatus.ScriptNotFound;
        }
        else if (!File.Exists(entryFile))
        {
            Console.WriteLine($"File '{Path.GetFileName(entryFile)}' does not exist.");
            return ExitStatus.ScriptNotFound;
        }

        HRuntimeMembers.ProjectDirectory = TryGetDirectory(entryFile);
        HRuntimeMembers.ImportedScripts.Add(entryFile);

        return ExitStatus.Success;
    }

    /// <summary>
    /// Loads a file into <see cref="HRuntimeMembers"/> to be run
    /// </summary>
    /// <param name="path"></param>
    public static void LoadScript(string path)
    {
        var sw = Stopwatch.StartNew();

        // Start the lexer
        HRuntimeMembers.HLexer = new(new AntlrInputStream(new StreamReader(path)));
        Verbose.Log($"Lex took: {sw.ElapsedMilliseconds}ms");
        sw.Restart();

        // Start the parser
        HRuntimeMembers.HParser = new(new CommonTokenStream(HRuntimeMembers.HLexer));
        Verbose.Log($"Parse took: {sw.ElapsedMilliseconds}ms");
        
        sw.Stop();
    }

    /// <summary>
    /// Loads the entry script, and runs it
    /// </summary>
    /// <param name="entryFile"></param>
    /// <returns></returns>
    public static ExitStatus StartProjectFromEntryFile(string entryFile)
    {
        // Load the entry file
        LoadScript(entryFile);

        // Create a new HRuntime (script visitor)
        var visitor = new HRuntime();

        // The parsed script
        var program = HRuntimeMembers.HParser.program();

        var sw = Stopwatch.StartNew();
        try
        {
            HRuntimeMembers.Initialize();
            
            //Console.WriteLine("Caching...");
            //File.WriteAllBytes("parse-tree.cache", SerializeToBson(program));
            //File.WriteAllBytes("lex-tree.cache", SerializeToBson(HRuntimeMembers.HLexer));

            visitor.Visit(program);

        }
        catch (Exception e)
        {
            Verbose.Log($"hellscript: {e.Message}");
        }

        Verbose.Log($"Program took: {sw.ElapsedMilliseconds}ms");

        return ExitStatus.Success;
    }

    /// <summary>
    /// Gets the absolute path of a file, even if the relative path was provided
    /// </summary>
    /// <param name="path"></param>
    /// <returns></returns>
    private static string TryGetDirectory(string path)
    {
        try
        {
            return new FileInfo(path).Directory.FullName;
        }
        catch (Exception e)
        {
            Console.WriteLine($"Failed to get directory name: {e.Message}");
            Environment.Exit((int)ExitStatus.FailedToFetchProjectInformation);
        }

        return null;
    }

    private static byte[] SerializeToBson<T>(T obj) where T : class
    {
        using var memoryStream = new MemoryStream();
        using var bsonWriter = new BsonDataWriter(memoryStream);
        var serializer = new JsonSerializer();

        serializer.Serialize(bsonWriter, obj);
        return memoryStream.ToArray();
    }

    private static T DeserializeFromBson<T>(byte[] bsonData) where T : class
    {
        using var memoryStream = new MemoryStream(bsonData);
        using var bsonReader = new BsonDataReader(memoryStream);

        var serializer = new JsonSerializer();
        return serializer.Deserialize<T>(bsonReader);
    }
}
