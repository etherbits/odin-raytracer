package main

normalize_position :: proc(ctx: Ctx, x, y: int) -> [2]f64 {
	w, h := ctx.format.width, ctx.format.height
	return [2]f64{f64(x) / f64(w - 1), f64(y) / f64(h - 1)}
}
