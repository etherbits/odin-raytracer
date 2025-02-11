package main
import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:os"

main :: proc() {
	// Passing the image output file path
	ctx := init_ctx("out.ppm")

	// Write the header for ppm file format
	write_head(ctx)

	render(ctx)
}
