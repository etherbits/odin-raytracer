package main
import "core:fmt"
import "core:math"
import "core:math/linalg"

init_camera :: proc(args: CameraArgs) -> Camera {
	using args

	focal_length := linalg.length(position - look_at)
	vtheta := math.to_radians(vfov_deg)
	h := math.tan(vtheta / 2)
	viewport_height := 2. * h * focus_dist
	viewport_width := (f64(image_width) / f64(image_height)) * viewport_height
	vup := [3]f64{0, 0, 1}
	v := linalg.normalize(look_at - position)
	u := linalg.normalize(linalg.cross(vup, -v))
	w := linalg.cross(v, u)
	pixel_sample_scale := 1. / samples_per_pixel
	viewport_u := viewport_width * u
	viewport_v := viewport_height * w
	delta_u_pixel := viewport_u / f64(image_width)
	delta_v_pixel := viewport_v / f64(image_height)
	viewport_tl := position + (focus_dist * v) - (viewport_u / 2) - (viewport_v / 2)
	tl_pixel := viewport_tl + (delta_u_pixel + delta_v_pixel) / 2
	defocus_radius := focus_dist * math.tan(math.to_radians(defocus_deg / 2))
	defocus_disk_u := defocus_radius * u
	defocus_disk_v := defocus_radius * w

	return Camera {
		ray_bounce_depth,
		viewport_width,
		viewport_height,
		samples_per_pixel,
		pixel_sample_scale,
		defocus_deg,
		focus_dist,
		position,
		viewport_u,
		viewport_v,
		delta_u_pixel,
		delta_v_pixel,
		viewport_tl,
		tl_pixel,
		look_at,
		vup,
		u,
		v,
		w,
		defocus_disk_u,
		defocus_disk_v,
	}
}

Camera :: struct {
	ray_bounce_depth:                                                            int,
	viewport_width, viewport_height, samples_per_pixel, pixel_sample_scale:      f64,
	defocus_deg, focus_dist:                                                     f64,
	position, viewport_u, viewport_v, delta_u_pixel, delta_v_pixel, viewport_tl: [3]f64,
	tl_pixel, look_at, vup, u, v, w, defocus_disk_u, defocus_disk_v:             [3]f64,
}


CameraArgs :: struct {
	image_width, image_height, ray_bounce_depth:          int,
	vfov_deg, samples_per_pixel, defocus_deg, focus_dist: f64,
	position, look_at:                                    [3]f64,
}
