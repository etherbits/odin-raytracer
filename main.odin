package main
import "core:fmt"
import "core:math"
import "core:os"

WIDTH := 256
HEIGHT := 256

main :: proc() {
	fmt.printf("P3\n%v %v\n255\n", WIDTH, HEIGHT)

	for y in 0 ..< HEIGHT {
		for x in 0 ..< WIDTH {
			col := [3]f64 {
				f64(clamp(x - y, 0, 255)),
				f64(clamp(y - x, 0, 255)),
				f64(clamp(((x + y) / 2) - abs(x - y), 0, 255)),
			}

			fmt.printfln("%i %i %i", int(col.r), int(col.g), int(col.b))
		}
	}
}
