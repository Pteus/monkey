package main

import "core:fmt"
import "core:io"
import "core:os"

main :: proc() {
	fmt.printfln("Welcome to monkey - odin edition")
	reader := os.to_reader(os.stdin)
	writer := os.to_writer(os.stdout)

	repl_start(reader, writer)
}
