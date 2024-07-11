/*

BINPL (v1.0-preview1 / July 12, 2024)
Copyright (c) 2024 Cyril John Magayaga

*/
import * as fs from "fs";
import * as path from "path";

const BINPL_VERSION = "v1.0-preview1";

// Function to interpret binary code
function interpretBinary(binaryCode: string, decimalMode: boolean, hexadecimalMode: boolean): void {
    const len = binaryCode.length;

    // Make sure the length is a multiple of 8
    if (len % 8 !== 0) {
        console.error("Error: Invalid binary string length");
        process.exit(1);
    }

    // Iterate through the binary string, interpreting each group of 8 bits
    for (let i = 0; i < len; i += 8) {
        let decimalValue = 0;
        for (let j = 0; j < 8; j++) {
            decimalValue = (decimalValue << 1) | (binaryCode.charCodeAt(i + j) - "0".charCodeAt(0));
        }
        if (decimalMode) {
            process.stdout.write(decimalValue + " ");
        }
        
        else if (hexadecimalMode) {
            process.stdout.write(decimalValue.toString(16).toUpperCase() + " ");
        }
        
        else {
            process.stdout.write(String.fromCharCode(decimalValue));
        }
    }
    console.log();
}

// Main function
function main(): number {
    const args = process.argv.slice(2);
    
    if (args.length !== 1 && args.length !== 2) {
        console.log("Usage: binpl [binary file]");
        return 1;
    }

    const option = args[0];
    
    if (option === "-h" || option === "--help") {
        console.log("Usage: binpl [binary file] [-d or --decimalMode] [-h or --hexadecimal]");
        console.log("       -v or --version       Version information.");
        console.log("       -h or --help          Usage information.");
        console.log("       -d or --decimal       Interpret binary as decimal numbers.");
        console.log("       -h or --hexadecimal   Interpret binary as hexadecimal numbers.");
        console.log("       --author              Author information.");
        return 0;
    } 
    
    if (option === "-v" || option === "--version") {
        console.log(BINPL_VERSION);
        return 0;
    }
    
    if (option === "--author") {
        console.log("Copyright (c) 2024 Cyril John Magayaga");
        return 0;
    }

    const filePath = args[0];
    if (!fs.existsSync(filePath)) {
        console.error(`Error: Unable to open file "${filePath}"`);
        return 1;
    }

    const binaryCode = fs.readFileSync(filePath, "utf8");

    let decimalMode = false; // Default mode: ASCII interpretation
    let hexadecimalMode = false; // Default mode: ASCII interpretation

    if (args.length === 2) {
        if (args[1] === "-d" || args[1] === "--decimal") {
            decimalMode = true;
        }
        
        else if (args[1] === "-h" || args[1] === "--hexadecimal") {
            hexadecimalMode = true;
        }
        
        else {
            console.error(`Error: Invalid option "${args[1]}"`);
            return 1;
        }
    }

    // Parse binary code, skipping comments
    const lines = binaryCode.split("\n");
    for (const line of lines) {
        if (!line.startsWith(";;")) {
            interpretBinary(line, decimalMode, hexadecimalMode);
        }
    }

    return 0;
}

// Run main function
main();