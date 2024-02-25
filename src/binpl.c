#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BINPL_VERSION "v1.0-preview0"

// Function prototypes
void interpretBinary(const char *binaryCode, int decimalMode, int hexadecimalMode);

int main(int argc, char *argv[]) {
    if (argc != 2 && argc != 3) {
        printf("Usage: binpl [binary file]\n");
        return 1;
    }

    // Check for help option
    if (argc == 2 && (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0)) {
        printf("Usage: binpl [binary file] [-d or --decimalMode] [-h or --hexadecimal]\n");
        printf("       -v or --version       Version information.\n");
        printf("       -h or --help          Usage information.\n");
        printf("       -d or --decimal       Interpret binary as decimal numbers.\n");
        printf("       -h or --hexadecimal   Interpret binary as hexadecimal numbers.\n");
        printf("       --author              Author information.");
        return 0;
    }

    else if (argc == 2 && (strcmp(argv[1], "-v") == 0 || strcmp(argv[1], "--version") == 0)) {
        printf("%s\n", BINPL_VERSION);
        return 0;
    }

    else if (argc == 2 && (strcmp(argv[1], "--author") == 0)) {
        printf("Copyright (c) 2024 Cyril John Magayaga\n");
        return 0;
    }
    
    FILE *file;
    if (fopen_s(&file, argv[1], "rb") != 0) {
        printf("Error: Unable to open file '%s'\n", argv[1]);
        return 1;
    }
    
    fseek(file, 0, SEEK_END);
    long fileSize = ftell(file);
    fseek(file, 0, SEEK_SET);
    
    char *binaryCode = (char *)malloc(fileSize + 1);
    if (!binaryCode) {
        fclose(file);
        printf("Error: Memory allocation failed\n");
        return 1;
    }
    
    fread(binaryCode, 1, fileSize, file);
    binaryCode[fileSize] = '\0';
    fclose(file);
    
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
            printf("Error: Invalid option '%s'\n", argv[2]);
            return 1;
        }
    }
    
    interpretBinary(binaryCode, decimalMode, hexadecimalMode);
    
    free(binaryCode);
    
    return 0;
}

void interpretBinary(const char *binaryCode, int decimalMode, int hexadecimalMode) {
    int len = strlen(binaryCode);
    
    // Make sure the length is a multiple of 8
    if (len % 8 != 0) {
        printf("Error: Invalid binary string length\n");
        exit(1);
    }
    
    // Iterate through the binary string, interpreting each group of 8 bits
    for (int i = 0; i < len; i += 8) {
        int decimalValue = 0;
        for (int j = 0; j < 8; j++) {
            decimalValue = (decimalValue << 1) | (binaryCode[i + j] - '0');
        }
        if (decimalMode) {
            printf("%d ", decimalValue);
        }
        
        else if (hexadecimalMode) {
            printf("%02X ", decimalValue);
        }
        
        else {
            printf("%c", (char)decimalValue);
        }
    }
    printf("\n");
}
