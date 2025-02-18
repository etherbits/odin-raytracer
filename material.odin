package main
import "core:fmt"
import "core:math/linalg"

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

scatter :: proc(ctx: Ctx, ray: Ray, rec: HitRecord) -> (Ray, [3]f64, bool) {
	switch obj in rec.material {
	case Lambertian:
		return scatter_lambertian(ctx, ray, rec)
	case Metal:
		return scatter_metal(ctx, ray, rec)
	case BaseMaterial:
	}
	fmt.panicf("No scatter function for material")
}

Material :: union {
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
