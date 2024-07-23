;
; BINPL (v1.0-preview1 / July 12, 2024)
; Copyright (c) 2024 Cyril John Magayaga
;
section .data
    usage db 'Usage: binpl [binary file] [-d or --decimal] [-h or --hexadecimal]', 10, 0
    version db 'v1.0-preview1', 10, 0
    author db 'Copyright (c) 2024 Cyril John Magayaga', 10, 0
    error_file_open db 'Error: Unable to open file ', 0
    error_memory_msg db 'Error: Memory allocation failed', 10, 0
    error_invalid_option_msg db 'Error: Invalid option', 10, 0
    error_invalid_length_msg db 'Error: Invalid binary string length', 10, 0
    putchar_format db '%c', 0

section .bss
    file_handle resq 1
    file_size resq 1
    buffer resb 1024

section .text
    extern fopen, fread, fclose, fseek, ftell, malloc, free, printf, exit, strcmp

    global _start

_start:
    ; Check arguments count
    mov rdi, [rsp + 8]     ; argc
    cmp rdi, 2
    je short process_args
    cmp rdi, 3
    je short process_args
    jmp print_usage

process_args:
    ; Check for help, version, or author options
    mov rsi, [rsp + 16]    ; argv[1]
    call strcmp_help
    cmp rax, 0
    je print_usage

    mov rsi, [rsp + 16]    ; argv[1]
    call strcmp_version
    cmp rax, 0
    je print_version

    mov rsi, [rsp + 16]    ; argv[1]
    call strcmp_author
    cmp rax, 0
    je print_author

    ; Open the binary file
    mov rdi, [rsp + 16]    ; argv[1]
    mov rsi, file_handle
    call fopen
    test rax, rax
    jz error_open_file

    ; Get file size
    mov rdi, [file_handle]
    mov rsi, 0
    mov rdx, 2
    call fseek

    call ftell
    mov [file_size], rax

    ; Allocate buffer
    mov rdi, [file_size]
    call malloc
    test rax, rax
    jz error_memory

    ; Read file content
    mov rdi, [file_handle]
    mov rsi, rax
    mov rdx, [file_size]
    call fread

    ; Close the file
    mov rdi, [file_handle]
    call fclose

    ; Interpret binary code (ASCII mode for simplicity)
    mov rsi, rax
    call interpret_binary

    ; Free buffer and exit
    mov rdi, rax
    call free

    ; Exit
    xor rdi, rdi
    call exit

print_usage:
    mov rdi, usage
    call printf
    xor rdi, rdi
    call exit

print_version:
    mov rdi, version
    call printf
    xor rdi, rdi
    call exit

print_author:
    mov rdi, author
    call printf
    xor rdi, rdi
    call exit

error_open_file:
    mov rdi, error_file_open
    call printf
    xor rdi, rdi
    call exit

error_memory:
    mov rdi, error_memory_msg
    call printf
    xor rdi, rdi
    call exit

error_invalid_option:
    mov rdi, error_invalid_option_msg
    call printf
    xor rdi, rdi
    call exit

error_invalid_length:
    mov rdi, error_invalid_length_msg
    call printf
    xor rdi, rdi
    call exit

interpret_binary:
    ; Interpret binary code as ASCII characters
    xor rdi, rdi
.loop:
    lodsb
    test al, al
    jz .done
    movzx rdi, al
    call putchar
    jmp .loop

.done:
    ret

putchar:
    ; Print a single character using printf
    mov rsi, rdi
    mov rdi, putchar_format
    call printf
    ret

strcmp_help:
    mov rdi, rsi
    mov rsi, str_h
    call strcmp
    test rax, rax
    jz .done
    mov rsi, str_help
    call strcmp
.done:
    ret

strcmp_version:
    mov rdi, rsi
    mov rsi, str_v
    call strcmp
    test rax, rax
    jz .done
    mov rsi, str_version
    call strcmp
.done:
    ret

strcmp_author:
    mov rdi, rsi
    mov rsi, str_author
    call strcmp
.done:
    ret

section .rodata
str_h db "-h", 0
str_help db "--help", 0
str_v db "-v", 0
str_version db "--version", 0
str_author db "--author", 0
