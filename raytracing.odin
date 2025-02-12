package main
import "core:fmt"
import "core:math"
import "core:math/linalg"

trace_viewport_pixel_color :: proc(ctx: Ctx, x, y: int) -> [3]f64 {
	cam := ctx.camera
	ray_origin := cam.tl_pixel + (f64(x) * cam.delta_u_pixel) + (f64(y) * cam.delta_v_pixel)
	ray_dir := ray_origin - cam.position
	ray := Ray{cam.position, ray_dir}
	return trace_ray_color(ctx, ray)
}

trace_ray_color :: proc(ctx: Ctx, ray: Ray) -> [3]f64 {
	hit, didHit := record_closest_hit(ctx.objects, ray, [2]f64{0, math.INF_F64}).(HitRecord)
	if didHit {
		return 0.5 * (hit.normal + [3]f64{1, 1, 1})
	}

	normalized_ray_dir := linalg.normalize(ray.direction)
	a := 0.5 * (normalized_ray_dir.z + 1.0)
	return math.lerp([3]f64{1, 1, 1}, [3]f64{0.3, 0.55, 1}, a)
}
