#+feature dynamic-literals

package main

Token_Type :: enum {
	ILLEGAL,
	EOF,
	// Identifiers + literals
	IDENT, // add, foobar, x, y, ...
	INT, // 1343456
	// Operators
	ASSIGN,
	PLUS,
	// Delimiters
	COMMA,
	SEMICOLON,
	LPAREN,
	RPAREN,
	LBRACE,
	RBRACE,
	// Keywords
	FUNCTION,
	LET,
}

Token :: struct {
	type:    Token_Type,
	literal: string,
}

keywords := map[string]Token_Type {
	"fn"  = .FUNCTION,
	"let" = .LET,
}

// checks the keywords table to see whether the given identifier is in fact a keyword
lookup_ident :: proc(ident: string) -> Token_Type {
	if tok, ok := keywords[ident]; ok {
		return tok
	}

	return .IDENT
}
