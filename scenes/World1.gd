extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("YSort/Player").main_node = self
	get_node("YSort/BasicZombie").main_node = self
	get_node("YSort/Rafale").main_node = self
	get_node("YSort/BouletUnique").main_node = self
	get_node("YSort/Shotgun").main_node = self
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
