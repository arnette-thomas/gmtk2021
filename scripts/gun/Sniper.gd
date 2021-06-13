extends GunBase

	
const BULLET_SPEEEEEED := 4000
#const RELOAD_TIME := 0.5
const SPRAY_ANGLE := deg2rad(10)
const FIRING_SPEED := 0.05
const DAMAGE := 4

var bullet_scene := load("res://scenes/Bullets/Bullet.tscn")

var image := load("res://sprites/sniper.png")
var image_evil := load("res://sprites/sniper_evil.png")

func _init().(BULLET_SPEEEEEED, SPRAY_ANGLE, FIRING_SPEED, DAMAGE) -> void:
	pass
	
	
func generate_bullets(position : Vector2, direction : Vector2) -> Array:
	Globals.camera.shake(100, 0.1, 300)
	var bullet_instance = bullet_scene.instance()
	bullet_instance.speed = velocity
	bullet_instance.setup(friendly, damage)
	bullet_instance.direction = direction.rotated(rand_range(-spray_angle/2, spray_angle/2))
	bullet_instance.position = position
	return [bullet_instance]
