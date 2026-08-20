package main

import "core:bufio"
import "core:fmt"
import "core:io"

PROMPT :: ">> "

repl_start :: proc(reader: io.Reader, writer: io.Writer) {
	scanner := bufio.Scanner{}
	bufio.scanner_init(&scanner, reader, context.temp_allocator)

	for {
		fmt.print(PROMPT)
		if !bufio.scan(&scanner) {
			return
		}

		line := bufio.scanner_text(&scanner)

		lexer := lexer_make(line)

		// for <init>; <condition>; <post>
		for tok := lexer_next_token(&lexer);
		    tok.type != Token_Type.Eof;
		    tok = lexer_next_token(&lexer) {
			fmt.printfln("%+v", tok)
		}
	}

	free_all(context.temp_allocator)
}
