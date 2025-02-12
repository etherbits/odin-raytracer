package main
import "core:os"

init_ctx :: proc(args: CtxArgs) -> Ctx {
	using args

	fd := init_file(out_path)
	ctx := Ctx {
		format = Format{width, int(f64(width) / aspect_ratio), 255},
		file   = File{fd, out_path},
	}

	cameraArgs := CameraArgs {
		position       = [3]f64{0, 0, 0},
		viewport_width = 3,
		focal_length   = 1,
		normal         = [3]f64{0, 1, 0},
		image_width    = width,
		image_height   = ctx.format.height,
	}
	camera := init_camera(cameraArgs)
	ctx.camera = camera
	ctx.objects = [dynamic]Object{}
	append(&ctx.objects, Sphere{position = [3]f64{0, 2, 0}, rotation = 0, scale = 1, radius = 1})

	return ctx
}

Ctx :: struct {
	format:  Format,
	file:    File,
	camera:  Camera,
	objects: [dynamic]Object,
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

CtxArgs :: struct {
	width:          int,
	aspect_ratio:   f64,
	viewport_scale: f64,
	out_path:       string,
}
