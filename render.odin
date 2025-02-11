package main
import "core:fmt"
import "core:os"

write_pixel :: proc(ctx: Ctx, color: [3]f64) {
	col := color * f64(ctx.format.max_col)
	color_str := fmt.tprintfln("%d %d %d", int(col.r), int(col.g), int(col.b))
	os.write_string(ctx.file.handle, color_str)
}

render :: proc(ctx: Ctx) {
	using ctx.format

	for y in 0 ..< height {
		fmt.printfln("Scanline: %d/%d", y + 1, height)
		for x in 0 ..< width {
			pos := normalize_position(ctx, x, y)
			col := [3]f64{pos[0], pos[1], 0.0}

			write_pixel(ctx, col)
		}
	}
}
