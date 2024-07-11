--
-- BINPL (v1.0-preview1 / July 12, 2024)
-- Copyright (c) 2024 Cyril John Magayaga
--

BINPL_VERSION = "v1.0-preview1"

-- Function to interpret binary code
function interpretBinary(binaryCode, decimalMode, hexadecimalMode)
    local len = #binaryCode

    -- Make sure the length is a multiple of 8
    if len % 8 ~= 0 then
        print("Error: Invalid binary string length")
        os.exit(1)
    end

    -- Iterate through the binary string, interpreting each group of 8 bits
    for i = 1, len, 8 do
        local decimalValue = 0
        for j = 0, 7 do
            decimalValue = (decimalValue << 1) | (binaryCode:sub(i + j, i + j) - '0')
        end
        
        if decimalMode then
            io.write(decimalValue .. " ")
        
        elseif hexadecimalMode then
            io.write(string.format("%02X ", decimalValue))
        
        else
            io.write(string.char(decimalValue))
        end
    end
    io.write("\n")
end

-- Main function
function main(args)
    if #args < 1 or #args > 2 then
        print("Usage: binpl [binary file] [-d or --decimal] [-h or --hexadecimal]")
        return
    end

    -- Check for help option
    if #args == 1 and (args[1] == "-h" or args[1] == "--help") then
        print("Usage: binpl [binary file] [-d or --decimal] [-h or --hexadecimal]")
        print("       -v or --version       Version information.")
        print("       -h or --help          Usage information.")
        print("       -d or --decimal       Interpret binary as decimal numbers.")
        print("       -h or --hexadecimal   Interpret binary as hexadecimal numbers.")
        print("       --author              Author information.")
        return
    end

    if #args == 1 and (args[1] == "-v" or args[1] == "--version") then
        print(BINPL_VERSION)
        return
    end

    if #args == 1 and (args[1] == "--author") then
        print("Copyright (c) 2024 Cyril John Magayaga")
        return
    end

    local file = io.open(args[1], "rb")
    if not file then
        print("Error: Unable to open file '" .. args[1] .. "'")
        return
    end

    local binaryCode = file:read("*a")
    file:close()

    local decimalMode = false -- Default mode: ASCII interpretation
    local hexadecimalMode = false -- Default mode: ASCII interpretation

    if #args == 2 then
        if args[2] == "-d" or args[2] == "--decimal" then
            decimalMode = true
        
        elseif args[2] == "-h" or args[2] == "--hexadecimal" then
            hexadecimalMode = true
        
        else
            print("Error: Invalid option '" .. args[2] .. "'")
            return
        end
    end

    -- Parse binary code, skipping comments
    for line in binaryCode:gmatch("[^\r\n]+") do
        if line:sub(1, 2) ~= ";;" then
            interpretBinary(line, decimalMode, hexadecimalMode)
        end
    end
end

main(arg)