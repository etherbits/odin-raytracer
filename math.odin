package main

Ray :: struct {
	origin:    [3]f64,
	direction: [3]f64,
}

ray_at :: proc(r: Ray, t: f64) -> [3]f64 {
	return r.origin + r.direction * t
}
