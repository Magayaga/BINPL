#include <iostream>
#include <fstream>
#include <string>

#define BINPL_VERSION "v1.0-preview0"

// Function prototypes
void interpretBinary(const std::string &binaryCode, int decimalMode, int hexadecimalMode);

int main(int argc, char *argv[]) {
    if (argc != 2 && argc != 3) {
        std::cout << "Usage: binpl [binary file]\n";
        return 1;
    }

    // Check for help option
    if (argc == 2 && (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0)) {
        std::cout << "Usage: binpl [binary file] [-d or --decimalMode] [-h or --hexadecimal]\n"
                  << "       -v or --version       Version information.\n"
                  << "       -h or --help          Usage information.\n"
                  << "       -d or --decimal       Interpret binary as decimal numbers.\n"
                  << "       -h or --hexadecimal   Interpret binary as hexadecimal numbers.\n"
                  << "       --author              Author information.";
        return 0;
    }
    
    else if (argc == 2 && (strcmp(argv[1], "-v") == 0 || strcmp(argv[1], "--version") == 0)) {
        std::cout << BINPL_VERSION << std::endl;
        return 0;
    }
    
    else if (argc == 2 && (strcmp(argv[1], "--author") == 0)) {
        std::cout << "Copyright (c) 2024 Cyril John Magayaga\n";
        return 0;
    }

    std::ifstream file(argv[1], std::ios::binary);
    if (!file.is_open()) {
        std::cerr << "Error: Unable to open file '" << argv[1] << "'\n";
        return 1;
    }

    file.seekg(0, std::ios::end);
    std::streampos fileSize = file.tellg();
    file.seekg(0, std::ios::beg);

    std::string binaryCode(fileSize, '\0');
    file.read(&binaryCode[0], fileSize);
    file.close();

    int decimalMode = 0; // Default mode: ASCII interpretation
    int hexadecimalMode = 0; // Default mode: ASCII interpretation

    if (argc == 3) {
        if (strcmp(argv[2], "-d") == 0 || strcmp(argv[2], "--decimal") == 0) {
            decimalMode = 1;
        }
        
        else if (strcmp(argv[2], "-h") == 0 || strcmp(argv[2], "--hexadecimal") == 0) {
            hexadecimalMode = 1;
        }
        
        else {
            std::cerr << "Error: Invalid option '" << argv[2] << "'\n";
            return 1;
        }
    }

    interpretBinary(binaryCode, decimalMode, hexadecimalMode);

    return 0;
}

void interpretBinary(const std::string &binaryCode, int decimalMode, int hexadecimalMode) {
    int len = binaryCode.length();

    // Make sure the length is a multiple of 8
    if (len % 8 != 0) {
        std::cerr << "Error: Invalid binary string length\n";
        exit(1);
    }

    // Iterate through the binary string, interpreting each group of 8 bits
    for (int i = 0; i < len; i += 8) {
        int decimalValue = 0;
        for (int j = 0; j < 8; j++) {
            decimalValue = (decimalValue << 1) | (binaryCode[i + j] - '0');
        }
        if (decimalMode) {
            std::cout << decimalValue << " ";
        }
        
        else if (hexadecimalMode) {
            std::cout << std::hex << std::uppercase << decimalValue << " ";
        }
        
        else {
            std::cout << static_cast<char>(decimalValue);
        }
    }
    std::cout << std::endl;
}
