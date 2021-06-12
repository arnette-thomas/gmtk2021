extends GunBase

	
const BULLET_SPEEEEEED := 4000
#const RELOAD_TIME := 0.5
const SPRAY_ANGLE := deg2rad(2)
const FIRING_SPEED := 0.8

var bullet_scene := load("res://scenes/Bullet.tscn")

func _init().(BULLET_SPEEEEEED, SPRAY_ANGLE, FIRING_SPEED) -> void:
	pass
	
	
func generate_bullets(position : Vector2, direction : Vector2) -> Array:
	var bullet_instance = bullet_scene.instance()
	bullet_instance.speed = BULLET_SPEEEEEED
	bullet_instance.direction = direction.rotated(rand_range(-SPRAY_ANGLE/2, SPRAY_ANGLE/2))
	bullet_instance.position = position
	return [bullet_instance]
