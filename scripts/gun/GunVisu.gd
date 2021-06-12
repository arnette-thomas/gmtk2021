extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const RADIUS := 70
onready var boisson_au_citron := $Sprite
var gun_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gun_position = get_local_mouse_position().normalized() * RADIUS
	boisson_au_citron.position = gun_position
	boisson_au_citron.rotation = gun_position.angle()
	if gun_position.angle() > PI/2 || gun_position.angle() < - PI/2:
		boisson_au_citron.set_flip_v(true)
	else :
		boisson_au_citron.set_flip_v(false)
	
func fire():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("kick")
