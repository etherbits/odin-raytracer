package main
import "core:math"
import "core:math/linalg"
import "core:mem"

record_closest_hit :: proc(
	objects: [dynamic]Object,
	ray: Ray,
	interval: Interval,
) -> Maybe(HitRecord) {
	temp_rec := HitRecord{}
	min_t := interval.max
	hit_something := false

	for obj in objects {
		switch obj in obj {
		case Sphere:
			hit, didHit := sphere_hit(obj, ray, Interval{interval.min, min_t}).(HitRecord)
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

sphere_hit :: proc(sphere: Sphere, ray: Ray, t_range: Interval) -> Maybe(HitRecord) {
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
	if !interval_surrounds(t_range, root) {
		root = (h - dsqrt) / a
		if !interval_surrounds(t_range, root) {
			return nil
		}
	}

	rec := HitRecord{}

	rec.t = root
	rec.point = ray_at(ray, root)
	rec.normal = (rec.point - sphere.position) / sphere.radius
	rec.material = sphere.material


	return rec
}

set_hit_record_face_normal :: proc(rec: ^HitRecord, ray: Ray, outward_normal: [3]f64) {
	rec.front_face = linalg.dot(ray.direction, outward_normal) < 0
	rec.normal = rec.front_face ? outward_normal : -outward_normal
}

HitRecord :: struct {
	t:          f64,
	point:      [3]f64,
	normal:     [3]f64,
	front_face: bool,
	material:   Material,
}
