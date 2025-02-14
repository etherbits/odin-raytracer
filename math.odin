package main
import "core:math"
import "core:math/linalg"
import "core:math/rand"

Ray :: struct {
	origin:    [3]f64,
	direction: [3]f64,
}

Interval :: struct {
	min: f64,
	max: f64,
}

ray_at :: proc(r: Ray, t: f64) -> [3]f64 {
	return r.origin + r.direction * t
}

interval_contains :: proc(interval: Interval, x: f64) -> bool {
	using interval
	return min <= x && x <= max
}

interval_surrounds :: proc(interval: Interval, x: f64) -> bool {
	using interval
	return min < x && x < max
}

interval_size :: proc(interval: Interval) -> f64 {
	using interval
	return max - min
}

interval_clamp :: proc(interval: Interval, x: f64) -> f64 {
	using interval
	return math.clamp(x, min, max)
}

rand_vector :: proc() -> [3]f64 {
	return [3]f64{rand.float64(), rand.float64(), rand.float64()}
}

rand_vector_in_range :: proc(min, max: f64) -> [3]f64 {
	return [3]f64 {
		rand.float64_range(min, max),
		rand.float64_range(min, max),
		rand.float64_range(min, max),
	}
}

rand_unit_vector :: proc() -> [3]f64 {
	for {
		v := rand_vector_in_range(-1, 1)
		v_len2 := linalg.length2(v)
		if v_len2 > 1e-160 && v_len2 <= 1 {
			return v / math.sqrt(v_len2)
		}
	}
}

rand_uniform_bounce_ray :: proc(normal: [3]f64) -> [3]f64 {
	in_unit_sphere := rand_unit_vector()
	if linalg.dot(in_unit_sphere, normal) > 0 {
		return in_unit_sphere
	}
	return -in_unit_sphere
}

rand_lambertian_bounce_ray :: proc(normal: [3]f64) -> [3]f64 {
	return normal + rand_unit_vector()
}
