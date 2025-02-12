package main

Object :: union {
	Sphere,
	BaseObject,
}

BaseObject :: struct {
	position: [3]f64,
	rotation: [3]f64,
	scale:    [3]f64,
}

Sphere :: struct {
	using object: BaseObject,
	radius:       f64,
}
