package main

import "core:testing"

@(test)
test_lexer_next_token :: proc(t: ^testing.T) {
	input := `let five = 5;
let add = fn(x, y) {
  x + y;
};
let result = add(five, ten);
`

	expected := []Token {
		{.LET, "let"},
		{.IDENT, "five"},
		{.ASSIGN, "="},
		{.INT, "5"},
		{.SEMICOLON, ";"},
		{.LET, "let"},
		{.IDENT, "add"},
		{.ASSIGN, "="},
		{.FUNCTION, "fn"},
		{.LPAREN, "("},
		{.IDENT, "x"},
		{.COMMA, ","},
		{.IDENT, "y"},
		{.RPAREN, ")"},
		{.LBRACE, "{"},
		{.IDENT, "x"},
		{.PLUS, "+"},
		{.IDENT, "y"},
		{.SEMICOLON, ";"},
		{.RBRACE, "}"},
		{.SEMICOLON, ";"},
		{.LET, "let"},
		{.IDENT, "result"},
		{.ASSIGN, "="},
		{.IDENT, "add"},
		{.LPAREN, "("},
		{.IDENT, "five"},
		{.COMMA, ","},
		{.IDENT, "ten"},
		{.RPAREN, ")"},
		{.SEMICOLON, ";"},
		{.EOF, ""},
	}

	l := lexer_make(input)

	for exp, i in expected {
		tok := lexer_next_token(&l)
		testing.expectf(
			t,
			tok.type == exp.type,
			"test[%d] - token type wrong. expected=%v, got=%v",
			i,
			exp.type,
			tok.type,
		)
		testing.expectf(
			t,
			tok.literal == exp.literal,
			"test[%d] - literal wrong. expected=%q, got=%q",
			i,
			exp.literal,
			tok.literal,
		)
	}
}
