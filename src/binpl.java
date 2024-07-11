/*

BINPL (v1.0-preview1 / July 12, 2024)
Copyright (c) 2024 Cyril John Magayaga

*/
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class binpl {
    private static final String BINPL_VERSION = "v1.0-preview1";

    public static void main(String[] args) {
        if (args.length != 1 && args.length != 2) {
            System.out.println("Usage: binpl [binary file]");
            return;
        }

        // Check for help option
        if (args.length == 1 && (args[0].equals("-h") || args[0].equals("--help"))) {
            System.out.println("Usage: binpl [binary file] [-d or --decimalMode] [-h or --hexadecimal]");
            System.out.println("       -v or --version       Version information.");
            System.out.println("       -h or --help          Usage information.");
            System.out.println("       -d or --decimal       Interpret binary as decimal numbers.");
            System.out.println("       -h or --hexadecimal   Interpret binary as hexadecimal numbers.");
            System.out.println("       --author              Author information.");
            return;
        }

        if (args.length == 1 && (args[0].equals("-v") || args[0].equals("--version"))) {
            System.out.println(BINPL_VERSION);
            return;
        }

        if (args.length == 1 && args[0].equals("--author")) {
            System.out.println("Copyright (c) 2024 Cyril John Magayaga");
            return;
        }

        String binaryCode = "";
        try {
            binaryCode = new String(Files.readAllBytes(Paths.get(args[0])));
        } catch (IOException e) {
            System.err.println("Error: Unable to open file '" + args[0] + "'");
            return;
        }

        boolean decimalMode = false; // Default mode: ASCII interpretation
        boolean hexadecimalMode = false; // Default mode: ASCII interpretation

        if (args.length == 2) {
            if (args[1].equals("-d") || args[1].equals("--decimal")) {
                decimalMode = true;
            }
            
            else if (args[1].equals("-h") || args[1].equals("--hexadecimal")) {
                hexadecimalMode = true;
            }
            
            else {
                System.err.println("Error: Invalid option '" + args[1] + "'");
                return;
            }
        }

        Scanner scanner = new Scanner(binaryCode);
        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            if (!line.startsWith(";;")) {
                interpretBinary(line, decimalMode, hexadecimalMode);
            }
        }
    }

    private static void interpretBinary(String binaryCode, boolean decimalMode, boolean hexadecimalMode) {
        int len = binaryCode.length();

        // Make sure the length is a multiple of 8
        if (len % 8 != 0) {
            System.err.println("Error: Invalid binary string length");
            System.exit(1);
        }

        // Iterate through the binary string, interpreting each group of 8 bits
        for (int i = 0; i < len; i += 8) {
            int decimalValue = 0;
            for (int j = 0; j < 8; j++) {
                decimalValue = (decimalValue << 1) | (binaryCode.charAt(i + j) - '0');
            }

            if (decimalMode) {
                System.out.print(decimalValue + " ");
            }
            
            else if (hexadecimalMode) {
                System.out.print(Integer.toHexString(decimalValue) + " ");
            }
            
            else {
                System.out.print((char) decimalValue);
            }
        }
        System.out.println();
    }
}