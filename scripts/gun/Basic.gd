extends GunBase

	
const BULLET_SPEEEEEED := 1201
#const RELOAD_TIME := 0.3
const SPRAY_ANGLE := deg2rad(4)
const FIRING_SPEED := 0.3
const DAMAGE := 12

var image := load("res://sprites/arme_basique.png")
var image_evil := load("res://sprites/arme_basique_evil.png")

var bullet_scene := load("res://scenes/Bullets/Bullet.tscn")
var sfx_ = load("res://sfx/pistol_shoot.wav")

func _init().(BULLET_SPEEEEEED, SPRAY_ANGLE, FIRING_SPEED, DAMAGE, sfx_) -> void:
	pass
	
	
func generate_bullets(position : Vector2, direction : Vector2) -> Array:
	Globals.camera.shake(100, 0.1, 100)
	var bullet_instance = bullet_scene.instance()
	bullet_instance.setup(friendly, damage)
	bullet_instance.speed = velocity
	bullet_instance.direction = direction.rotated(rand_range(-spray_angle/2, spray_angle/2))
	bullet_instance.position = position
	return [bullet_instance]
