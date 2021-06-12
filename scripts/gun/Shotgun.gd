extends GunBase

	
const BULLET_SPEEEEEED := 1201
#const RELOAD_TIME := 0.3
const SPRAY_ANGLE := deg2rad(40)
const FIRING_SPEED := 0.5
const BULLETS_NUMBER := 9

var bullet_scene := load("res://scenes/Bullet.tscn")

func _init().(BULLET_SPEEEEEED, SPRAY_ANGLE, FIRING_SPEED) -> void:
	pass
	
	
func generate_bullets(position : Vector2, direction : Vector2) -> Array:
	var bullet_instances = Array()
	for i in BULLETS_NUMBER :
		var bullet_instance = bullet_scene.instance()
		bullet_instance.speed = BULLET_SPEEEEEED
		bullet_instance.direction = direction.rotated(rand_range(-SPRAY_ANGLE/2, SPRAY_ANGLE/2))
		bullet_instance.position = position
		bullet_instances.append(bullet_instance)
	return bullet_instances
