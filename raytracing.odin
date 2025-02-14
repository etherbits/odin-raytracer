package main
import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:math/rand"

sample_square :: proc() -> [3]f64 {
	return [3]f64{rand.float64() - 0.5, 0, rand.float64() - 0.5}

}

get_ray :: proc(cam: Camera, y, x: f64) -> Ray {
	offset := sample_square()
	pixel_sample :=
		cam.tl_pixel + ((x + offset.x) * cam.delta_u_pixel) + ((y + offset.z) * cam.delta_v_pixel)

	return Ray{cam.position, pixel_sample - cam.position}

}

trace_viewport_pixel_color :: proc(ctx: Ctx, x, y: int) -> [3]f64 {
	cam := ctx.camera
	col := [3]f64{0, 0, 0}
	for i in 0 ..< int(cam.samples_per_pixel) {
		ray := get_ray(cam, f64(y), f64(x))
		col += trace_ray_color(ctx, cam.ray_bounce_depth, ray)
	}

	return col * cam.pixel_sample_scale
}

trace_ray_color :: proc(ctx: Ctx, depth: int, ray: Ray) -> [3]f64 {
	if depth < 0 {
		return [3]f64{0, 0, 0}
	}

	hit, didHit := record_closest_hit(ctx.objects, ray, Interval{0.001, math.INF_F64}).(HitRecord)
	if didHit {
		bounce_dir := rand_lambertian_bounce_ray(hit.normal)
		bounce_ray := Ray{hit.point, bounce_dir}
		return 0.5 * trace_ray_color(ctx, depth - 1, bounce_ray)
	}

	normalized_ray_dir := linalg.normalize(ray.direction)
	a := 0.5 * (normalized_ray_dir.z + 1.0)
	return math.lerp([3]f64{1, 1, 1}, [3]f64{0.3, 0.55, 1}, a)
}
