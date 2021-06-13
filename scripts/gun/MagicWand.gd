extends GunBase

	
const BULLET_SPEEEEEED := 1201
#const RELOAD_TIME := 0.3
const SPRAY_ANGLE := deg2rad(15)
const FIRING_SPEED := 0.3

var image := load("res://sprites/baton.png")

var bullet_scene := load("res://scenes/Bullets/Bullet.tscn")

func _init().(BULLET_SPEEEEEED, SPRAY_ANGLE, FIRING_SPEED, 0) -> void:
	pass
	
	
func generate_bullets(position : Vector2, direction : Vector2) -> Array:
	Globals.camera.shake(100, 0.1, 100)
	var bullet_instance = bullet_scene.instance()
	bullet_instance.speed = BULLET_SPEEEEEED
	bullet_instance.direction = direction.rotated(rand_range(-SPRAY_ANGLE/2, SPRAY_ANGLE/2))
	bullet_instance.position = position
	bullet_instance.setup(friendly, 0)
	return [bullet_instance]
