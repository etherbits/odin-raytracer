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
		image_width       = width,
		image_height      = ctx.format.height,
		viewport_width    = 3.556,
		focal_length      = 1,
		samples_per_pixel = 32,
		ray_bounce_depth  = 10,
		position          = [3]f64{0, 0, 0},
		normal            = [3]f64{0, 1, 0},
	}
	camera := init_camera(cameraArgs)
	ctx.camera = camera
	ctx.objects = [dynamic]Object{}
	mat_ground := Lambertian {
		albedo = [3]f64{0.8, 0.8, 0},
	}
	mat_center := Lambertian {
		albedo = [3]f64{0.1, 0.2, 0.5},
	}
	mat_left := Metal {
		albedo = [3]f64{0.8, 0.8, 0.8},
		fuzz   = 0.8,
	}
	mat_top := Metal {
		albedo = [3]f64{0.4, 0.6, 0.9},
		fuzz   = 0.6,
	}
	mat_right := Metal {
		albedo = [3]f64{0.6, 0.6, 0.6},
		fuzz   = 0.005,
	}
	append(&ctx.objects, Sphere{{mat_ground, [3]f64{0, 1, -100.5}, 0, 1}, 100})
	append(&ctx.objects, Sphere{{mat_center, [3]f64{0, 1.5, 0}, 0, 1}, 0.5})
	append(&ctx.objects, Sphere{{mat_left, [3]f64{-1, 1, 0}, 0, 1}, 0.5})
	append(&ctx.objects, Sphere{{mat_top, [3]f64{1, 2, 1}, 0, 1}, 0.5})
	append(&ctx.objects, Sphere{{mat_right, [3]f64{2, 1.4, 0.1}, 0, 1}, 0.6})

	return ctx
}


clean_ctx :: proc(ctx: Ctx) {
	os.close(ctx.file.handle)
	delete(ctx.objects)
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
