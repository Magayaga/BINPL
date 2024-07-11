/*

BINPL (v1.0-preview1 / July 12, 2024)
Copyright (c) 2024 Cyril John Magayaga

*/
using System;
using System.IO;

public class Binpl
{
    private const string BINPL_VERSION = "v1.0-preview1";

    public static void Main(string[] args)
    {
        if (args.Length < 1)
        {
            Console.WriteLine("Usage: binpl [binary file] [-d or --decimal] [-h or --hexadecimal]");
            return;
        }

        if (args.Length == 1 && (args[0] == "-h" || args[0] == "--help"))
        {
            PrintUsage();
            return;
        }

        string filePath = args[0];

        if (!File.Exists(filePath))
        {
            Console.WriteLine($"Error: Unable to open file '{filePath}'");
            return;
        }

        string binaryCode = File.ReadAllText(filePath);

        int decimalMode = 0; // Default mode: ASCII interpretation
        int hexadecimalMode = 0; // Default mode: ASCII interpretation

        if (args.Length > 1)
        {
            for (int i = 1; i < args.Length; i++)
            {
                if (args[i] == "-d" || args[i] == "--decimal")
                {
                    decimalMode = 1;
                }
                
                else if (args[i] == "-h" || args[i] == "--hexadecimal")
                {
                    hexadecimalMode = 1;
                }
                
                else if (args[i] == "-v" || args[i] == "--version")
                {
                    Console.WriteLine(BINPL_VERSION);
                    return;
                }
                
                else if (args[i] == "--author")
                {
                    Console.WriteLine("Copyright (c) 2024 Cyril John Magayaga");
                    return;
                }
                
                else
                {
                    Console.WriteLine($"Error: Invalid option '{args[i]}'");
                    PrintUsage();
                    return;
                }
            }
        }

        // Parse binary code, skipping comments
        string[] lines = binaryCode.Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.None);
        foreach (string line in lines)
        {
            if (!line.StartsWith(";;"))
            {
                InterpretBinary(line, decimalMode, hexadecimalMode);
            }
        }
    }

    private static void InterpretBinary(string binaryCode, int decimalMode, int hexadecimalMode)
    {
        int len = binaryCode.Length;

        // Make sure the length is a multiple of 8
        if (len % 8 != 0)
        {
            Console.WriteLine("Error: Invalid binary string length");
            Environment.Exit(1);
        }

        // Iterate through the binary string, interpreting each group of 8 bits
        for (int i = 0; i < len; i += 8)
        {
            int decimalValue = 0;
            for (int j = 0; j < 8; j++)
            {
                decimalValue = (decimalValue << 1) | (binaryCode[i + j] - '0');
            }

            if (decimalMode != 0)
            {
                Console.Write($"{decimalValue} ");
            }
            
            else if (hexadecimalMode != 0)
            {
                Console.Write($"{decimalValue:X2} ");
            }
            
            else
            {
                Console.Write($"{(char)decimalValue}");
            }
        }
        Console.WriteLine();
    }

    private static void PrintUsage()
    {
        Console.WriteLine("Usage: binpl [binary file] [-d or --decimal] [-h or --hexadecimal]");
        Console.WriteLine("       -v or --version       Version information.");
        Console.WriteLine("       -h or --help          Usage information.");
        Console.WriteLine("       -d or --decimal       Interpret binary as decimal numbers.");
        Console.WriteLine("       -h or --hexadecimal   Interpret binary as hexadecimal numbers.");
        Console.WriteLine("       --author              Author information.");
    }
}
