package main
import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:os"

main :: proc() {
	ctxArgs := CtxArgs {
		out_path = "out.ppm",
	}
	ctx := init_ctx(ctxArgs)
	defer clean_ctx(ctx)

	// Write the header for ppm file format
	write_head(ctx)

	render(ctx)
}
