class_name GunBase
extends Object

var velocity : float  # En pxl / s
var spray_angle : float # En radians
var reload_time : float  # En secondes


func _init(velocity_ : float, spray_angle_ : float, reload_time_ : float):
	velocity = velocity_
	spray_angle = spray_angle_
	reload_time = reload_time_

# Retourne un tableau des bullets créés
func generate_bullets(position : Vector2, direction : Vector2) -> Array:
	print("/!\\ Do not call GunBase's default generate_bullet() function")
	return []
