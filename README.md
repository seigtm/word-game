# Word Game

This repository houses a word game program developed in x86_64 NASM as a coursework project for the **Computer Architecture** course at **St. Petersburg Polytechnic University**. The program challenges players to create words from a specified string, ensuring they are valid based on the characters and exist in a provided dictionary.

## Project Files

- `coursework.nasm`: The main NASM source code file containing the implementation of the word game.
- `macro.nasm`: An external file providing macro and constant definitions used in the main program.

## Game Description

The word game operates as follows:

- Players take turns entering a word, adhering to the following rules:
  - The word must be composed of characters from the given source string.
  - The word must exist in the dictionary.

- The game ends when a player enters an incorrect word, and the program prints a corresponding message.

## Usage

Execute the `./run.sh` script bundled with the source code.

Follow the on-screen prompts to enter words and play the game.

## Source Code Overview

- `section .rodata`: Contains read-only data such as rules, prompts, source string, dictionary, and messages.
- `section .bss`: Reserves space for variables like user input buffer.
- `section .text`: The main program logic, including the game loop and interaction with C library functions.

## Building and Running

Ensure NASM and a compatible linker are installed on your system. The provided compilation commands assume a Linux (//WSL) environment.

## TODO

1. Implement the conversion of user input to lowercase characters.
2. Dictionary expansion.
