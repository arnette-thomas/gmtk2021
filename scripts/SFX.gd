extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play(sound_name):
	var sound = get_node(sound_name) as AudioStreamPlayer
	if sound == null:
		print_debug("Sound " + sound_name + " not found")
		return
		
	sound.play()
