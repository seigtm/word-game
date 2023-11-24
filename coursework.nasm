; 6. Develop a word game: who can come up with more words from the characters of a given string.
;    Check for:
;      - validity based on characters;
;      - existence in the dictionary.
;    Allow for dictionary expansion and ignore case sensitivity (А = а).

%include 'macro.nasm'  ; Include external macro and constants definitions.

section .rodata
    ; Game rules string.
    rules db `Игра в слова на английском языке!\n`
          db `Правила: игроки по очереди вводят по одному слову.\n`
          db `Слово должно состоять из символов заданной строки, а также принадлежать словарю.\n`
          db `Это означает, что нельзя писать несуществующие слова, либо же слова, содержащие другие символы.\n`
          db `Игра оканчивается как только один из игроков введёт некорректное слово.\n`
          db `Слова можно писать в любом регистре, высота букв игнорируется.\n\n`, 0
    rules_len equ $ - rules ; Length of the rules string.

    source_string_prompt     db  'Исходная строка, из букв которой вам необходимо составлять слова: ', 0 ; Prompt for source string.
    source_string_prompt_len equ $ - source_string_prompt                                                ; Prompt for source string length.
    source_string            db  `ehllo\n`, 0                                                            ; Source string for word formation.
    source_string_len        equ $ - source_string                                                       ; Source string length.

    delimiter db " ", 0 ; Delimiter is space symbol.

    incorrect_msg db `Слово не найдено в словаре! Игра окончена, вы проиграли :)\n`, 0 ; Incorrect message string
    correct_msg   db `Слово найдено в словаре! Теперь очередь следующего игрока!\n`, 0 ; Correct message (found) string.

    string_format db "%s", 0 ; Format string for Cprintf.

    ; hello - привет, приветствие.
    ; hell - ад, место в религиозных представлениях, предназначенное для наказания грешников.
    ; hole - отверстие, яма, дыра.
    ; hoe - мотыга, садовый инструмент для рыхления почвы.
    ; lo - сокращение от "low" (низкий), также используется как устное выражение в значении "привет" или "пока".
    ; ole - устаревшая форма слова "oil" (масло) или в испанском языке может быть использовано как восклицание поддержки.
    ; ell - небольшая комната или помещение.
    dictionary     db  'hello hell hole hoe lo ole ell', 0 ; Space-separated dictionary words.
    dictionary_len equ $ - dictionary                      ; Length of the dictionary string.

section .bss
    user_input      resb BUFFER_SIZE ; Buffer to hold user input.
    dictionary_copy resb BUFFER_SIZE ; Copy of the dictionary for tokenization.

section .text
    global  main
    extern  scanf, printf, strtok, strcmp ; Extern C functions from C library.
    default rel  ; RIP-relative addressing for [name].

main:
    ; Create a stack-frame, realigning the stack to 16-byte alignment before calls.
    push rbp
    mov  rbp, rsp

    ; Write rules and source string to stdout.
    Cprintf rules,                string_format
    Cprintf source_string_prompt, string_format
    Cprintf source_string,        string_format

    game_loop:
        ; Read user input.
        Cscanf string_format, user_input
        ; TODO: Convert all characters in the user input string to lowercase.

        ; Copy the dictionary to a writable area for tokenization.
        lea rdi, [dictionary_copy]
        lea rsi, [dictionary]
        mov rcx, dictionary_len
        rep  movsb

        ; Tokenize the dictionary string by delimiter (space).
        ;   char* token = strtok(dictionary, delimiter);
        Cstrtok dictionary_copy, delimiter
        ; Result in RAX.

        ; Compare the user input with each token in the dictionary.
        ; while(token != NULL)
        ;     if(strcmp(token, input) == 0)
        ;         printf("FOUND!\n");
        ;     token = strtok(NULL, delimiters);
        ; }
        compare_loop:
            test rax, rax  ; Set ZF to 1 if RAX == 0 (token == NULL).
            jz   game_over ; Game ends if the token is NULL (end of dictionary).

            ; Now compare the current token in dictionary with user input.
            lea  rdi, [rax]
            lea  rsi, [user_input]
            call strcmp            ; strcmp(token, input)

            ; If strcmp returned 0, the word is found. Print a message and continue the game loop.
            test rax, rax
            jz   word_found ; Word found if strcmp(token, input) == 0.

            ; If not, continue tokenizing.
            Cstrtok delimiter    ; Move to the next token = strtok(NULL, delimiters).
            ; Result (next token, e.g., the next word from the dictionary) in RAX.
            jmp     compare_loop

            word_found:
                Cprintf correct_msg, string_format
                jmp     game_loop                  ; Continue the game loop.

            ; Someone accidently or by purpose entered the wrong word.
            game_over:
                Cprintf incorrect_msg, string_format
                xor     eax,           eax           ; Set zero (EXIT_SUCCESS).
                leave
                ret
