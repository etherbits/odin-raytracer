package main
import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:os"

WIDTH := 1024
HEIGHT := 1024
COLOR_MAX := 255
OUT_PATH := "out.ppm"

main :: proc() {
	// Create and open output file
	flags := os.O_RDWR | os.O_CREATE | os.O_APPEND | os.O_TRUNC
	mode: int = 0o644

	fd, err := os.open(OUT_PATH, flags, mode)
	if err != os.ERROR_NONE {
		fmt.eprintf("Failed to open or create file: %v\n", err)
		return
	}

	head_str := fmt.tprintfln("P3\n%v %v\n%v", WIDTH, HEIGHT, COLOR_MAX)
	os.write_string(fd, head_str)
	a := linalg.length([3]f64{1., 1., 1.})


	for y in 0 ..< HEIGHT {
		fmt.printfln("Scanline: %d/%d", y + 1, HEIGHT)
		for x in 0 ..< WIDTH {
			pos := normalize_position(x, y, HEIGHT, WIDTH)
			col := [3]f64{pos[0], pos[1], 0.0}


			write_pixel(fd, col)
		}
	}
}
