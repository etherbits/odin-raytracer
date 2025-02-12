package main
import "core:math"
import "core:math/linalg"


record_closest_hit :: proc(
	objects: [dynamic]Object,
	ray: Ray,
	t_range: [2]f64,
) -> Maybe(HitRecord) {
	temp_rec := HitRecord{}
	min_t := t_range[1]
	hit_something := false

	for obj in objects {
		switch obj in obj {
		case Sphere:
			hit, didHit := sphere_hit(obj, ray, [2]f64{t_range[0], min_t}).(HitRecord)
			if didHit {
				hit_something = true
				if hit.t < min_t {
					temp_rec = hit
					min_t = temp_rec.t
				}
			}
		case BaseObject:
			continue
		}
	}

	return temp_rec if hit_something else nil

}

sphere_hit :: proc(sphere: Sphere, ray: Ray, t_range: [2]f64) -> Maybe(HitRecord) {
	pos_diff := sphere.position - ray.origin
	a := linalg.length2(ray.direction)
	h := linalg.dot(pos_diff, ray.direction)
	c := linalg.dot(pos_diff, pos_diff) - sphere.radius * sphere.radius
	discriminant := h * h - a * c

	if discriminant < 0 {
		return nil
	}

	dsqrt := math.sqrt(discriminant)
	root := (h - dsqrt) / a
	if root <= t_range[0] || root > t_range[1] {
		root = (h - dsqrt) / a
		if root <= t_range[0] || root > t_range[1] {
			return nil
		}
	}

	rec := HitRecord{}

	rec.t = root
	rec.point = ray_at(ray, root)
	rec.normal = (rec.point - sphere.position) / sphere.radius


	return rec
}

set_hit_record_face_normal :: proc(rec: ^HitRecord, ray: Ray, outward_normal: [3]f64) {
	rec.front_face = linalg.dot(ray.direction, outward_normal) < 0
	rec.normal = rec.front_face ? outward_normal : -outward_normal
}


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

HitRecord :: struct {
	t:          f64,
	point:      [3]f64,
	normal:     [3]f64,
	front_face: bool,
}
