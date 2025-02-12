package main
import "core:fmt"
import "core:math"
import "core:math/linalg"

trace_viewport_pixel_color :: proc(ctx: Ctx, x, y: int) -> [3]f64 {
	cam := ctx.camera
	ray_origin := cam.tl_pixel + (f64(x) * cam.delta_u_pixel) + (f64(y) * cam.delta_v_pixel)
	ray_dir := ray_origin - cam.position
	ray := Ray{ray_origin, ray_dir}
	return trace_ray_color(ctx, ray)
}

trace_ray_color :: proc(ctx: Ctx, ray: Ray) -> [3]f64 {
	switch obj in ctx.objects[0] {
	case Sphere:
		if hit_sphere(obj, ray) {
			return {1, 0, 0}
		}
	case BaseObject:
		return {0, 0, 0}
	}

	normalized_ray_dir := linalg.normalize(ray.direction)
	a := 0.5 * (normalized_ray_dir.z + 1.0)
	return math.lerp([3]f64{1, 1, 1}, [3]f64{0.3, 0.55, 1}, a)
}

hit_sphere :: proc(sphere: Sphere, ray: Ray) -> bool {
	pos_diff := sphere.position - ray.origin
	a := linalg.dot(ray.direction, ray.direction)
	b := -2.0 * linalg.dot(pos_diff, ray.direction)
	c := linalg.dot(pos_diff, pos_diff) - sphere.radius * sphere.radius
	discriminant := b * b - 4 * a * c

	return discriminant >= 0
}
