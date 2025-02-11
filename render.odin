package main
import "core:fmt"
import "core:os"

write_pixel :: proc(fd: os.Handle, color: [3]f64) {
	col := color * f64(COLOR_MAX)
	color_str := fmt.tprintfln("%d %d %d", int(col.r), int(col.g), int(col.b))
	os.write_string(fd, color_str)
}
