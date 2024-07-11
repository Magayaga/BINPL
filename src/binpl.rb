#
#
# BINPL (v1.0-preview1 / July 12, 2024)
# Copyright (c) 2024 Cyril John Magayaga
#
#

#!/usr/bin/env ruby

BINPL_VERSION = "v1.0-preview1"

# Function to interpret binary code based on modes
def interpret_binary(binary_code, decimal_mode, hexadecimal_mode)
  len = binary_code.length

  # Ensure the length is a multiple of 8
  if len % 8 != 0
    puts "Error: Invalid binary string length"
    exit(1)
  end

  result = ""
  (0...len).step(8) do |i|
    decimal_value = 0
    8.times do |j|
      decimal_value = (decimal_value << 1) | (binary_code[i + j].to_i)
    end

    if decimal_mode
      result += "#{decimal_value} "
    
    elsif hexadecimal_mode
      result += "%02X " % decimal_value
    
    else
      result += decimal_value.chr
    end
  end

  result.strip
end

# Main program logic
if ARGV.length != 1 && ARGV.length != 2
  puts "Usage: binpl [binary file] [-d or --decimal] [-h or --hexadecimal]"
  exit(1)
end

case ARGV[0]
when "-h", "--help"
  puts "Usage: binpl [binary file] [-d or --decimal] [-h or --hexadecimal]"
  puts "       -v or --version       Version information."
  puts "       -h or --help          Usage information."
  puts "       -d or --decimal       Interpret binary as decimal numbers."
  puts "       -h or --hexadecimal   Interpret binary as hexadecimal numbers."
  puts "       --author              Author information."
  exit(0)
when "-v", "--version"
  puts BINPL_VERSION
  exit(0)
when "--author"
  puts "Copyright (c) 2024 Cyril John Magayaga"
  exit(0)
end

file_path = ARGV[0]

begin
  binary_code = File.read(file_path).strip

  decimal_mode = false
  hexadecimal_mode = false

  if ARGV.length == 2
    case ARGV[1]
    when "-d", "--decimal"
      decimal_mode = true
    
    when "-h", "--hexadecimal"
      hexadecimal_mode = true
    
    else
      puts "Error: Invalid option '#{ARGV[1]}'"
      exit(1)
    end
  end

  # Parse binary code, skipping comments
  binary_code.each_line do |line|
    line.strip!
    next if line.start_with?(";;")

    result = interpret_binary(line, decimal_mode, hexadecimal_mode)
    puts result
  end

rescue Errno::ENOENT
  puts "Error: Unable to open file '#{file_path}'"
  exit(1)
end
