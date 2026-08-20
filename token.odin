#+feature dynamic-literals

package main

Token_Type :: enum {
	Illegal,
	Eof,
	// Identifiers + literals
	Ident, // add, foobar, x, y, ...
	Int, // 1343456
	// Operators
	Assign,
	Plus,
	Minus,
	Bang,
	Asterisk,
	Slash,
	LT,
	GT,
	Eq,
	Not_Eq,

	// Delimiters
	Comma,
	Semicolon,
	L_Paren,
	R_Paren,
	L_Brace,
	R_Brace,
	// Keywords
	Function,
	Let,
	True,
	False,
	If,
	Else,
	Return,
}

Token :: struct {
	type:    Token_Type,
	literal: string,
}

keywords := map[string]Token_Type {
	"fn"     = .Function,
	"let"    = .Let,
	"true"   = .True,
	"false"  = .False,
	"if"     = .If,
	"else"   = .Else,
	"return" = .Return,
}

// checks the keywords table to see whether the given identifier is in fact a keyword
lookup_ident :: proc(ident: string) -> Token_Type {
	if tok, ok := keywords[ident]; ok {
		return tok
	}

	return .Ident
}
