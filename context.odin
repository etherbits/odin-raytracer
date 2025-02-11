package main
import "core:os"

init_ctx :: proc(out_path: string) -> Ctx {
	fd := init_file(out_path)

	return Ctx{format = Format{1024, 1024, 255}, file = File{fd, out_path}}
}

Ctx :: struct {
	format: Format,
	file:   File,
}

Format :: struct {
	width:   int,
	height:  int,
	max_col: int,
}

File :: struct {
	handle: os.Handle,
	path:   string,
}
