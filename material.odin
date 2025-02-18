package main
import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:math/rand"

scatter_lambertian :: proc(ctx: Ctx, ray: Ray, rec: HitRecord) -> (Ray, [3]f64, bool) {
	scatter_direction := rand_lambertian_bounce_ray(rec.normal)
	if near_zero(scatter_direction) {
		scatter_direction = rec.normal
	}
	return Ray{rec.point, scatter_direction}, rec.material.(Lambertian).albedo, true
}


scatter_metal :: proc(ctx: Ctx, ray: Ray, rec: HitRecord) -> (Ray, [3]f64, bool) {
	reflect_direction := reflect(ray.direction, rec.normal)
	reflect_direction =
		linalg.normalize(reflect_direction) + rec.material.(Metal).fuzz * rand_unit_vector()
	if linalg.dot(reflect_direction, rec.normal) > 0 {
		return Ray{rec.point, reflect_direction}, rec.material.(Metal).albedo, true
	}
	return Ray{}, [3]f64{}, false
}

scatter_dielectric :: proc(ctx: Ctx, ray: Ray, rec: HitRecord) -> (Ray, [3]f64, bool) {
	ir := rec.front_face ? (1.0 / rec.material.(Dielectric).ir) : rec.material.(Dielectric).ir
	u_dir := linalg.normalize(ray.direction)
	cos_theta := math.min(linalg.dot(-u_dir, rec.normal), 1.)
	sin_theta := math.sqrt(1. - cos_theta * cos_theta)
	cannot_refract := sin_theta * ir > 1.0

	scatter_direction: [3]f64
	if (cannot_refract || reflectance(cos_theta, ir) > rand.float64()) {
		scatter_direction = reflect(u_dir, rec.normal)
	} else {
		scatter_direction = refract(u_dir, rec.normal, ir)
	}

	scattered := Ray{rec.point, scatter_direction}
	return scattered, [3]f64{1, 1, 1}, true
}

scatter :: proc(ctx: Ctx, ray: Ray, rec: HitRecord) -> (Ray, [3]f64, bool) {
	switch mat in rec.material {
	case Lambertian:
		return scatter_lambertian(ctx, ray, rec)
	case Metal:
		return scatter_metal(ctx, ray, rec)
	case Dielectric:
		return scatter_dielectric(ctx, ray, rec)
	case BaseMaterial:
	}
	fmt.panicf("No scatter function for material")
}

Material :: union {
	Dielectric,
	Lambertian,
	Metal,
	BaseMaterial,
}

BaseMaterial :: struct {
	albedo: [3]f64,
}

Lambertian :: struct {
	using material: BaseMaterial,
}

Metal :: struct {
	using material: BaseMaterial,
	fuzz:           f64,
}

Dielectric :: struct {
	using material: BaseMaterial,
	ir:             f64,
}
