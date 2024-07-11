#
#
# BINPL (v1.0-preview1 / July 12, 2024)
# Copyright (c) 2024 Cyril John Magayaga
#
#
import sys

BINPL_VERSION = "v1.0-preview1"

def interpret_binary(binary_code, decimal_mode, hexadecimal_mode):
    length = len(binary_code)

    # Make sure the length is a multiple of 8
    if length % 8 != 0:
        print("Error: Invalid binary string length")
        sys.exit(1)

    # Iterate through the binary string, interpreting each group of 8 bits
    for i in range(0, length, 8):
        decimal_value = int(binary_code[i:i+8], 2)
        if decimal_mode:
            print(decimal_value, end=" ")
        elif hexadecimal_mode:
            print(f"{decimal_value:02X}", end=" ")
        else:
            print(chr(decimal_value), end="")
    print()

def main():
    if len(sys.argv) != 2 and len(sys.argv) != 3:
        print("Usage: binpl [binary file]")
        return 1

    # Check for help option
    if len(sys.argv) == 2:
        if sys.argv[1] in ("-h", "--help"):
            print("Usage: binpl [binary file] [-d or --decimalMode] [-h or --hexadecimal]")
            print("       -v or --version       Version information.")
            print("       -h or --help          Usage information.")
            print("       -d or --decimal       Interpret binary as decimal numbers.")
            print("       -h or --hexadecimal   Interpret binary as hexadecimal numbers.")
            print("       --author              Author information.")
            return 0
        
        elif sys.argv[1] in ("-v", "--version"):
            print(BINPL_VERSION)
            return 0
        
        elif sys.argv[1] == "--author":
            print("Copyright (c) 2024 Cyril John Magayaga")
            return 0

    try:
        with open(sys.argv[1], "r") as file:
            lines = file.readlines()
    except IOError:
        print(f"Error: Unable to open file '{sys.argv[1]}'")
        return 1

    decimal_mode = False  # Default mode: ASCII interpretation
    hexadecimal_mode = False  # Default mode: ASCII interpretation

    if len(sys.argv) == 3:
        if sys.argv[2] in ("-d", "--decimal"):
            decimal_mode = True
        
        elif sys.argv[2] in ("-h", "--hexadecimal"):
            hexadecimal_mode = True
        
        else:
            print(f"Error: Invalid option '{sys.argv[2]}'")
            return 1

    for line in lines:
        line = line.strip()
        if not line.startswith(";;"):
            interpret_binary(line, decimal_mode, hexadecimal_mode)

    return 0

if __name__ == "__main__":
    sys.exit(main())
