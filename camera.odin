package main

init_camera :: proc(args: CameraArgs) -> Camera {
	using args

	aspect_ratio := f64(image_width) / f64(image_height)
	viewport_height := viewport_width / aspect_ratio
	viewport_u := [3]f64{viewport_width, 0, 0}
	viewport_v := [3]f64{0, 0, -viewport_height}
	delta_u_pixel := viewport_u / f64(image_width)
	delta_v_pixel := viewport_v / f64(image_height)
	viewport_tl := position + (focal_length * normal) - (viewport_u / 2) - (viewport_v / 2)
	tl_pixel := viewport_tl + (delta_u_pixel + delta_v_pixel) / 2

	return Camera {
		position,
		viewport_width,
		viewport_height,
		focal_length,
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
	position:        [3]f64,
	viewport_width:  f64,
	viewport_height: f64,
	focal_length:    f64,
	normal:          [3]f64,
	viewport_u:      [3]f64,
	viewport_v:      [3]f64,
	delta_u_pixel:   [3]f64,
	delta_v_pixel:   [3]f64,
	viewport_tl:     [3]f64,
	tl_pixel:        [3]f64,
}


CameraArgs :: struct {
	position:       [3]f64,
	viewport_width: f64,
	focal_length:   f64,
	normal:         [3]f64,
	image_width:    int,
	image_height:   int,
}
