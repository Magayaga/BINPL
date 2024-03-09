<p align="center">
  <a href="https://github.com/Magayaga/CyNeo">
    <img src="assets/logo.svg" width="200" height="200">
  </a>
</p>

<h1 align="center">BINPL</h1>

BINPL (also known as **Binary-like Programming Language**) is a low-level programming language that binary codes to execute machine code programs, decimal number systems, or hexadecimal number systems. It is the program that reads binary data from a file and interprets it based on the specified mode (decimal, hexadecimal, or ASCII character). It was written in **C**, **C++**, and **Rust** programming languages. It was created and developed on February 25, 2024, by Cyril John Magayaga, who is best known for the [Hyzero](https://github.com/magayaga/hyzero) and [Xenly](https://github.com/magayaga/xenly) programming languages.

BINPL is available on February 25, 2024 for the **Windows** operating system.

## Getting start

If you do want to try out BINPL locally, you'll need to install our build dependencies (Clang, rust, git) and check out the BINPL repository, for example on Windows:

```bash
# Download BINPL's code
$ git clone https://github.com/magayaga/BINPL.git
$ cd BINPL
```

Then you can build and run:

```bash
# Build and run (Choose the clang or rust)
$ clang src/binpl.c -o binpl
$ clang src/binpl.cpp -o binpl
$ rustc src/binpl.rs

# Open
./binpl examples/main.binpl
```

## Copyright

Copyright (c) 2024 Cyril John Magayaga. All rights reserved.

Licensed under the [Apache-2.0](LICENSE) license
