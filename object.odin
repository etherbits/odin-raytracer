package main


Object :: union {
	Sphere,
	BaseObject,
}

BaseObject :: struct {
	material: Material,
	position: [3]f64,
	rotation: [3]f64,
	scale:    [3]f64,
}

Sphere :: struct {
	using object: BaseObject,
	radius:       f64,
}
