; Constants:
%define BUFFER_SIZE  100 ; Size of the user input buffer.

; Macro that wraps clib scanf.
; Input: RSI - format, RDX - address of string.
%macro Cscanf 2
    lea  rdi, [%1]
    lea  rsi, [%2]
    xor  rax, rax
    call scanf
%endmacro

; Macro that wraps clib printf().
; Input: RSI - address of string, RDX - format.
%macro Cprintf 2
    lea  rdi, [%1]
    lea  rsi, [%2]
    xor  rax, rax
    call printf
%endmacro

; Macro that wraps clib strtok().
; Input: RDI - 1st arg of strktok(), RSI - 2nd arg of strtok().
; Output: Result of strtok() call in RAX.
%macro Cstrtok 2
    lea  rdi, [%1] ; Input string.
    lea  rsi, [%2] ; Delimiter.
    xor  rax, rax  ; Clear RAX before calling, because it would contain the result.
    call strtok    ; char* token = strtok(dictionary, delimiter);
%endmacro

; Macro that wraps clib strtok() but 1st arg is always NULL.
; Input: RSI - 2nd arg of strtok().
; Output: Result of strtok() call in RAX.
%macro Cstrtok 1
    xor  rdi, rdi  ; Because the first param to strtok should be NULL == 0.
    lea  rsi, [%1] ; The second param is the same delimiter.
    xor  rax, rax  ; Clear RAX before calling, because it would contain the result.
    call strtok    ; token = strtok(NULL, delimiters);
%endmacro
