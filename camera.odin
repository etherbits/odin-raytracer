package main

init_camera :: proc(args: CameraArgs) -> Camera {
	using args

	aspect_ratio := f64(image_width) / f64(image_height)
	viewport_height := viewport_width / aspect_ratio
	pixel_sample_scale := 1. / samples_per_pixel
	viewport_u := [3]f64{viewport_width, 0, 0}
	viewport_v := [3]f64{0, 0, -viewport_height}
	delta_u_pixel := viewport_u / f64(image_width)
	delta_v_pixel := viewport_v / f64(image_height)
	viewport_tl := position + (focal_length * normal) - (viewport_u / 2) - (viewport_v / 2)
	tl_pixel := viewport_tl + (delta_u_pixel + delta_v_pixel) / 2

	return Camera {
		viewport_width,
		viewport_height,
		focal_length,
		samples_per_pixel,
		pixel_sample_scale,
		position,
		normal,
		viewport_u,
		viewport_v,
		delta_u_pixel,
		delta_v_pixel,
		viewport_tl,
		tl_pixel,
	}
}

Camera :: struct {
	viewport_width, viewport_height, focal_length, samples_per_pixel, pixel_sample_scale:          f64,
	position, normal, viewport_u, viewport_v, delta_u_pixel, delta_v_pixel, viewport_tl, tl_pixel: [3]f64,
}


CameraArgs :: struct {
	image_width, image_height:                       int,
	viewport_width, focal_length, samples_per_pixel: f64,
	position, normal:                                [3]f64,
}
