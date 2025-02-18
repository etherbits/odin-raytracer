package main
import "core:math"
import "core:math/linalg"
import "core:math/rand"
import "core:os"

init_ctx :: proc(args: CtxArgs) -> Ctx {
	using args

	aspect_ratio := 16.0 / 9.0
	width := 1340

	fd := init_file(out_path)
	ctx := Ctx {
		format = Format{width, int(f64(width) / aspect_ratio), 255},
		file   = File{fd, out_path},
	}

	cameraArgs := CameraArgs {
		image_width       = width,
		image_height      = ctx.format.height,
		vfov_deg          = 28,
		samples_per_pixel = 520,
		ray_bounce_depth  = 48,
		position          = [3]f64{9, -8, 4},
		look_at           = [3]f64{1.5, 0, 0.6},
		defocus_deg       = 0.6,
		focus_dist        = 10.,
	}
	camera := init_camera(cameraArgs)
	ctx.camera = camera
	ctx.objects = [dynamic]Object{}
	ground_material := Metal {
		albedo = [3]f64{0.2, 0.22, 0.23},
		fuzz   = 0.4,
	}
	append(&ctx.objects, Sphere{{ground_material, [3]f64{0, 0, -1000}, 0, 1}, 1000})

	for a in -8 ..< 8 {
		for b in -8 ..< 8 {
			choose_mat := rand.float64()
			r := rand.float64_range(0.08, 0.25)
			center := [3]f64 {
				f64(a) * 1.5 + 0.9 * rand.float64(),
				-f64(b) * 1.5 + 0.9 * rand.float64(),
				r,
			}

			if (linalg.length(center - [3]f64{4, 0.2, 0})) > 0.9 {
				if choose_mat < 0.8 {
					// diffuse
					albedo := rand_vector() * rand_vector()
					albedo *= 2
					albedo = linalg.clamp(albedo, 0.1, 0.9)
					sphere_material := Lambertian {
						albedo = albedo,
					}
					append(&ctx.objects, Sphere{{sphere_material, center, 0, 1}, r})
				} else if choose_mat < 0.95 {
					// metal
					albedo := rand_vector_in_range(0.5, 1.0)
					fuzz := rand.float64_range(0, 1)
					sphere_material := Metal {
						albedo = albedo,
						fuzz   = fuzz,
					}
					append(&ctx.objects, Sphere{{sphere_material, center, 0, 1}, r})
				} else {
					// glass
					sphere_material := Dielectric {
						ir = 1.5,
					}
					append(&ctx.objects, Sphere{{sphere_material, center, 0, 1}, r})
				}
			}
		}
	}

	material1 := Dielectric {
		ir = 1.5,
	}
	append(&ctx.objects, Sphere{{material1, [3]f64{1.4, -2.9, 1}, 0, 1}, 1.0})

	material2 := Lambertian {
		albedo = [3]f64{0.3, 0.2, 0.6},
	}
	append(&ctx.objects, Sphere{{material2, [3]f64{-4, 0, 1}, 0, 1}, 1.0})

	material3 := Metal {
		albedo = [3]f64{0.6, 0.1, 0.52},
		fuzz   = 0.05,
	}
	append(&ctx.objects, Sphere{{material3, [3]f64{1.7, -0.4, 1.3}, 0, 1}, 1.3})
	material4 := Metal {
		albedo = [3]f64{0.7, 0.7, 0.78},
		fuzz   = 0.7,
	}
	append(&ctx.objects, Sphere{{material4, [3]f64{4, 1.2, 1}, 0, 1}, 1.0})

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
	out_path: string,
}
