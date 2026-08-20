package main

import "core:testing"

@(test)
test_lexer_next_token :: proc(t: ^testing.T) {
	input := `let five = 5;
let add = fn(x, y) {
  x + y;
};
let result = add(five, ten);
!-/*5;
5 < 10 > 5;
`

	expected := []Token {
		{.Let, "let"},
		{.Ident, "five"},
		{.Assign, "="},
		{.Int, "5"},
		{.Semicolon, ";"},
		{.Let, "let"},
		{.Ident, "add"},
		{.Assign, "="},
		{.Function, "fn"},
		{.L_Paren, "("},
		{.Ident, "x"},
		{.Comma, ","},
		{.Ident, "y"},
		{.R_Paren, ")"},
		{.L_Brace, "{"},
		{.Ident, "x"},
		{.Plus, "+"},
		{.Ident, "y"},
		{.Semicolon, ";"},
		{.R_Brace, "}"},
		{.Semicolon, ";"},
		{.Let, "let"},
		{.Ident, "result"},
		{.Assign, "="},
		{.Ident, "add"},
		{.L_Paren, "("},
		{.Ident, "five"},
		{.Comma, ","},
		{.Ident, "ten"},
		{.R_Paren, ")"},
		{.Semicolon, ";"},
		{.Bang, "!"},
		{.Minus, "-"},
		{.Slash, "/"},
		{.Asterisk, "*"},
		{.Int, "5"},
		{.Semicolon, ";"},
		{.Int, "5"},
		{.LT, "<"},
		{.Int, "10"},
		{.GT, ">"},
		{.Int, "5"},
		{.Semicolon, ";"},
		{.Eof, ""},
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
