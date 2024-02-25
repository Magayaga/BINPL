use std::env;
use std::fs::File;
use std::io::Read;

const BINPL_VERSION: &str = "v1.0-preview0";

fn main() {
    // Collect command line arguments into a vector of strings
    let args: Vec<String> = env::args().collect();
    
    // Check for the correct number of command line arguments
    if args.len() != 2 && args.len() != 3 {
        println!("Usage: binpl [binary file]");
        return;
    }

    // Check for help option
    if args.len() == 2 && (args[1] == "-h" || args[1] == "--help") {
        println!("Usage: binpl [binary file] [-d or --decimalMode] [-h or --hexadecimal]");
        println!("       -v or --version       Version information.");
        println!("       -h or --help          Usage information.");
        println!("       -d or --decimal       Interpret binary as decimal numbers.");
        println!("       -h or --hexadecimal   Interpret binary as hexadecimal numbers.");
        println!("       --author              Author information.");
        return;
    }
    
    else if args.len() == 2 && (args[1] == "-v" || args[1] == "--version") {
        // Print version information
        println!("{}", BINPL_VERSION);
        return;
    }
    
    else if args.len() == 2 && args[1] == "--author" {
        // Print author information
        println!("Copyright (c) 2024 Cyril John Magayaga");
        return;
    }
    
    // Open the file specified in the command line argument
    let file_name = &args[1];
    let mut file = match File::open(file_name) {
        Ok(f) => f,
        Err(_) => {
            println!("Error: Unable to open file '{}'", file_name);
            return;
        }
    };

    // Read the contents of the file into a string
    let mut binary_code = String::new();
    if let Err(_) = file.read_to_string(&mut binary_code) {
        println!("Error: Unable to read file '{}'", file_name);
        return;
    }

    // Determine the interpretation mode based on command line arguments
    let decimal_mode = if args.len() == 3 && (args[2] == "-d" || args[2] == "--decimal") {
        true
    }
    
    else {
        false
    };

    let hexadecimal_mode = if args.len() == 3 && (args[2] == "-h" || args[2] == "--hexadecimal") {
        true
    }
    
    else {
        false
    };

    // Interpret the binary code based on the selected mode
    interpret_binary(&binary_code, decimal_mode, hexadecimal_mode);
}

// Function to interpret binary code
fn interpret_binary(binary_code: &str, decimal_mode: bool, hexadecimal_mode: bool) {
    let len = binary_code.len();
    
    // Check if the length of the binary string is a multiple of 8
    if len % 8 != 0 {
        println!("Error: Invalid binary string length");
        return;
    }
    
    // Iterate through the binary string, interpreting each group of 8 bits
    for chunk in binary_code.chars().collect::<Vec<_>>().chunks(8) {
        let mut decimal_value = 0;
        // Convert each group of 8 bits to decimal value
        for &bit in chunk {
            decimal_value = (decimal_value << 1) | (bit as i32 - '0' as i32);
        }
        // Print the decimal value, hexadecimal value, or ASCII character based on the mode
        if decimal_mode {
            print!("{} ", decimal_value);
        }
        
        else if hexadecimal_mode {
            print!("{:02X} ", decimal_value);
        }
        
        else {
            print!("{}", (decimal_value as u8) as char);
        }
    }
    println!();
}
