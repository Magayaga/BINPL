/*

BINPL (v1.0-preview1 / July 12, 2024)
Copyright (c) 2024 Cyril John Magayaga

*/
package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

const BINPL_VERSION = "v1.0-preview1"

func interpretBinary(binaryCode string, decimalMode bool, hexadecimalMode bool) {
	len := len(binaryCode)

	// Ensure the length is a multiple of 8
	if len % 8 != 0 {
		fmt.Println("Error: Invalid binary string length")
		os.Exit(1)
	}

	// Iterate through the binary string, interpreting each group of 8 bits
	for i := 0; i < len; i += 8 {
		decimalValue := 0
		for j := 0; j < 8; j++ {
			decimalValue = (decimalValue << 1) | int(binaryCode[i + j] - '0')
		}
		
		if decimalMode {
			fmt.Printf("%d ", decimalValue)
		} else if hexadecimalMode {
			fmt.Printf("%02X ", decimalValue)
		} else {
			fmt.Printf("%c", decimalValue)
		}
	}
	fmt.Println()
}

func main() {
	args := os.Args[1:]

	if len(args) != 1 && len(args) != 2 {
		fmt.Println("Usage: binpl [binary file] [-d or --decimal] [-h or --hexadecimal]")
		os.Exit(1)
	}

	if len(args) == 1 && (args[0] == "-h" || args[0] == "--help") {
		fmt.Println("Usage: binpl [binary file] [-d or --decimal] [-h or --hexadecimal]")
		fmt.Println("       -v or --version       Version information.")
		fmt.Println("       -h or --help          Usage information.")
		fmt.Println("       -d or --decimal       Interpret binary as decimal numbers.")
		fmt.Println("       -h or --hexadecimal   Interpret binary as hexadecimal numbers.")
		fmt.Println("       --author              Author information.")
		os.Exit(0)
	}

	if len(args) == 1 && (args[0] == "-v" || args[0] == "--version") {
		fmt.Println(BINPL_VERSION)
		os.Exit(0)
	}

	if len(args) == 1 && (args[0] == "--author") {
		fmt.Println("Copyright (c) 2024 Cyril John Magayaga")
		os.Exit(0)
	}

	// Open the binary file
	file, err := os.Open(args[0])
	if err != nil {
		fmt.Printf("Error: Unable to open file '%s'\n", args[0])
		os.Exit(1)
	}
	defer file.Close()

	// Read the binary content
	scanner := bufio.NewScanner(file)
	var binaryCode string
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if !strings.HasPrefix(line, ";;") {
			binaryCode += line
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Println("Error reading file:", err)
		os.Exit(1)
	}

	// Determine mode from command-line arguments
	decimalMode := false
	hexadecimalMode := false

	if len(args) == 2 {
		if args[1] == "-d" || args[1] == "--decimal" {
			decimalMode = true
		} else if args[1] == "-h" || args[1] == "--hexadecimal" {
			hexadecimalMode = true
		} else {
			fmt.Printf("Error: Invalid option '%s'\n", args[1])
			os.Exit(1)
		}
	}

	// Interpret the binary code
	interpretBinary(binaryCode, decimalMode, hexadecimalMode)
}
