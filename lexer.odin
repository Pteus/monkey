package main


Lexer :: struct {
	input:         string,
	position:      int, // current position in input (points to current char), ie char that was already read
	read_position: int, // current reading position in input (after current char), ie next char
	ch:            byte, // current char under examination
	illegal_buf:   [1]byte, // stable storage — lives as long as the Lexer itself
}

lexer_make :: proc(input: string) -> Lexer {
	l := Lexer {
		input = input,
	}
	lexer_read_char(&l)

	return l
}

// The purpose of lexer_read_char is to give us the next character and advance our position in the input string
lexer_read_char :: proc(lexer: ^Lexer) {
	if lexer.read_position >= len(lexer.input) {
		lexer.ch = 0 // ASCII code for NUL
	} else {
		lexer.ch = lexer.input[lexer.read_position]
	}

	lexer.position = lexer.read_position
	lexer.read_position += 1
}

lexer_next_token :: proc(lexer: ^Lexer) -> Token {
	tok: Token

	lexer_skip_whitespace(lexer)

	switch lexer.ch {
	case '=':
		tok = Token{.Assign, "="}
	case '-':
		tok = Token{.Minus, "-"}
	case '!':
		tok = Token{.Bang, "!"}
	case '/':
		tok = Token{.Slash, "/"}
	case '*':
		tok = Token{.Asterisk, "*"}
	case '<':
		tok = Token{.LT, "<"}
	case '>':
		tok = Token{.GT, ">"}
	case ';':
		tok = Token{.Semicolon, ";"}
	case '(':
		tok = Token{.L_Paren, "("}
	case ')':
		tok = Token{.R_Paren, ")"}
	case ',':
		tok = Token{.Comma, ","}
	case '+':
		tok = Token{.Plus, "+"}
	case '{':
		tok = Token{.L_Brace, "{"}
	case '}':
		tok = Token{.R_Brace, "}"}
	case 0:
		tok = Token{.Eof, ""}
	case:
		if is_letter(lexer.ch) {
			tok.literal = lexer_read_identifier(lexer)
			tok.type = lookup_ident(tok.literal)
			return tok
		} else if is_digit(lexer.ch) {
			tok.literal = lexer_read_number(lexer)
			tok.type = .Int
			return tok
		} else {
			tok = Token{.Illegal, string([]u8{lexer.ch})} // probably doesnt work
		}
	}

	lexer_read_char(lexer)
	return tok
}

//reads in an identifier and advances
//our lexer’s positions until it encounters a non-letter-character
lexer_read_identifier :: proc(lexer: ^Lexer) -> string {
	position := lexer.position
	for is_letter(lexer.ch) {
		lexer_read_char(lexer)
	}

	return lexer.input[position:lexer.position]
}

// Checks whether the given argument is a letter.
is_letter :: proc(ch: byte) -> bool {
	return 'a' <= ch && ch <= 'z' || 'A' <= ch && ch <= 'Z' || ch == '_'
}

lexer_skip_whitespace :: proc(lexer: ^Lexer) {
	for lexer.ch == ' ' || lexer.ch == '\t' || lexer.ch == '\n' || lexer.ch == '\r' {
		lexer_read_char(lexer)
	}
}

lexer_read_number :: proc(lexer: ^Lexer) -> string {
	position := lexer.position
	for is_digit(lexer.ch) {
		lexer_read_char(lexer)
	}

	return lexer.input[position:lexer.position]
}

is_digit :: proc(ch: byte) -> bool {
	return '0' <= ch && ch <= '9'
}
