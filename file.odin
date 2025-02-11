package main
import "core:fmt"
import "core:os"

init_file :: proc(path: string) -> os.Handle {
	flags := os.O_RDWR | os.O_CREATE | os.O_APPEND | os.O_TRUNC
	mode: int = 0o644

	fd, err := os.open(path, flags, mode)
	if err != os.ERROR_NONE {
		fmt.panicf("Failed to open or create file: %v\n", err)
	}

	return fd
}

write_head :: proc(ctx: Ctx) {
	head_str := fmt.tprintfln(
		"P3\n%v %v\n%v",
		ctx.format.width,
		ctx.format.height,
		ctx.format.max_col,
	)
	os.write_string(ctx.file.handle, head_str)
}
