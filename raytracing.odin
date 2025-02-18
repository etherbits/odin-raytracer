package main
import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:math/rand"


get_ray :: proc(cam: Camera, y, x: f64) -> Ray {
	offset := sample_square()
	pixel_sample :=
		cam.tl_pixel + ((x + offset.x) * cam.delta_u_pixel) + ((y + offset.z) * cam.delta_v_pixel)

	ray_origin := (cam.defocus_deg <= 0) ? cam.position : defocus_disk_sample(cam)
	direction := pixel_sample - ray_origin
	return Ray{ray_origin, direction}

}

sample_square :: proc() -> [3]f64 {
	return [3]f64{rand.float64() - 0.5, 0, rand.float64() - 0.5}
}

defocus_disk_sample :: proc(cam: Camera) -> [3]f64 {
	point := rand_disk_unit_vector()
	return cam.position + (cam.defocus_disk_u * point.x) + (cam.defocus_disk_v * point.y)
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
		bounce_ray, attenuation, didBounce := scatter(ctx, ray, hit)
		if didBounce {
			return attenuation * trace_ray_color(ctx, depth - 1, bounce_ray)
		}
		return [3]f64{0, 0, 0}
	}

	normalized_ray_dir := linalg.normalize(ray.direction)
	a := 0.5 * (normalized_ray_dir.z + 1.0)
	return math.lerp([3]f64{1, 1, 1}, [3]f64{0.5, 0.7, 1}, a)
}
