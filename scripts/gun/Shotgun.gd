extends GunBase

	
const BULLET_SPEEEEEED := 1201
#const RELOAD_TIME := 0.3
const SPRAY_ANGLE := deg2rad(40)
const FIRING_SPEED := 0.5
const DAMAGE = 8
const BULLETS_NUMBER := 9

var bullet_scene := load("res://scenes/Bullets/Bullet.tscn")

var image_evil := load("res://sprites/shotgun_evil.png")
var image := load("res://sprites/shotgun.png")

func _init().(BULLET_SPEEEEEED, SPRAY_ANGLE, FIRING_SPEED, DAMAGE) -> void:
	pass
	
	
func generate_bullets(position : Vector2, direction : Vector2) -> Array:
	Globals.camera.shake(500, 0.2, 500)
	var bullet_instances = Array()
	var bullets_number
	if friendly:
		bullets_number = BULLETS_NUMBER
	else:
		bullets_number = BULLETS_NUMBER / 2
		
	for i in bullets_number:
		var bullet_instance = bullet_scene.instance()
		bullet_instance.speed = velocity
		bullet_instance.direction = direction.rotated(rand_range(-spray_angle/2, spray_angle/2))
		bullet_instance.position = position
		bullet_instances.append(bullet_instance)
		bullet_instance.setup(friendly, damage)		
		bullet_instance.speed *= 0.8
	return bullet_instances
