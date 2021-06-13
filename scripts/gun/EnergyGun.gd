extends GunBase

	
const BULLET_SPEEEEEED := 1500
#const RELOAD_TIME := 0.5
const SPRAY_ANGLE := deg2rad(2)
const FIRING_SPEED := 0.8
const DAMAGE := 100

var image := load("res://sprites/energyGun.png")
var image_evil := load("res://sprites/energyGun_evil.png")

var bullet_scene := load("res://scenes/Bullets/GrosseBouboule.tscn")

func _init().(BULLET_SPEEEEEED, SPRAY_ANGLE, FIRING_SPEED, DAMAGE) -> void:
	pass
	
	
func generate_bullets(position : Vector2, direction : Vector2) -> Array:
	Globals.camera.shake(700, 0.1, 700)
	var bullet_instance = bullet_scene.instance()
	bullet_instance.speed = velocity
	bullet_instance.direction = direction.rotated(rand_range(-spray_angle/2, spray_angle/2))
	bullet_instance.position = position
	bullet_instance.setup(friendly, damage)
	return [bullet_instance]
