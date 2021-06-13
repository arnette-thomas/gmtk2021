extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var radius := 70
onready var boisson_au_citron := $Sprite
var gun_position
var gun : GunBase

var target_position # vecteur normalisé de l'origin vers le target

func setup(friendly_ : float):
	if not friendly_ :
		radius = 20
		boisson_au_citron.scale /= 1.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gun_position = target_position * radius
	boisson_au_citron.position = gun_position
	boisson_au_citron.rotation = gun_position.angle()
	if gun_position.angle() > PI/2 || gun_position.angle() < - PI/2:
		boisson_au_citron.set_flip_v(true)
	else :
		boisson_au_citron.set_flip_v(false)
	
func fire():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("kick")
	if gun != null && gun.sfx != null:
		var sfx_node = $ShootSFX
		(sfx_node.stream as AudioStreamRandomPitch).audio_stream = gun.sfx
		sfx_node.play()
