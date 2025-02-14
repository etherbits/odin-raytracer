package main

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
