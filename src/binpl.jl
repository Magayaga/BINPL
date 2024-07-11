using Printf

# Constants
const BINPL_VERSION = "v1.0-preview1"

# Function prototypes
function interpret_binary(binary_code::String, decimal_mode::Bool, hexadecimal_mode::Bool)
    len = length(binary_code)

    # Make sure the length is a multiple of 8
    if len % 8 != 0
        println("Error: Invalid binary string length")
        exit(1)
    end

    # Iterate through the binary string, interpreting each group of 8 bits
    for i in 1:8:len
        decimal_value = 0
        for j in 0:7
            decimal_value = (decimal_value << 1) | (parse(Int, binary_code[i + j]) - 0)
        end

        if decimal_mode
            print(decimal_value, " ")
        elseif hexadecimal_mode
            @printf("%02X ", decimal_value)
        else
            print(Char(decimal_value))
        end
    end
    println()
end

# Main function
function main(args)
    if length(args) != 1 && length(args) != 2
        println("Usage: binpl [binary file] [-d or --decimal] [-h or --hexadecimal]")
        return
    end

    # Check for help option
    if length(args) == 1 && (args[1] == "-h" || args[1] == "--help")
        println("Usage: binpl [binary file] [-d or --decimal] [-h or --hexadecimal]")
        println("       -v or --version       Version information.")
        println("       -h or --help          Usage information.")
        println("       -d or --decimal       Interpret binary as decimal numbers.")
        println("       -h or --hexadecimal   Interpret binary as hexadecimal numbers.")
        println("       --author              Author information.")
        return
    end

    if length(args) == 1 && (args[1] == "-v" || args[1] == "--version")
        println(BINPL_VERSION)
        return
    end

    if length(args) == 1 && (args[1] == "--author")
        println("Copyright (c) 2024 Cyril John Magayaga")
        return
    end

    # Open the binary file
    binary_code = read(args[1], String)
    decimal_mode = false # Default mode: ASCII interpretation
    hexadecimal_mode = false # Default mode: ASCII interpretation

    if length(args) == 2
        if args[2] == "-d" || args[2] == "--decimal"
            decimal_mode = true
        elseif args[2] == "-h" || args[2] == "--hexadecimal"
            hexadecimal_mode = true
        else
            println("Error: Invalid option '", args[2], "'")
            return
        end
    end

    # Parse binary code, skipping comments
    for line in split(binary_code, '\n')
        if !startswith(line, ";;")
            interpret_binary(String(line), decimal_mode, hexadecimal_mode)  # Convert SubString{String} to String
        end
    end
end

# Run the main function with command-line arguments
main(ARGS)
