package main

normalize_position :: proc(x, y, h, w: int) -> [2]f64 {
	return [2]f64{f64(x) / f64(w - 1), f64(y) / f64(h - 1)}
}
