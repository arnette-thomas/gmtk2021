extends Node2D


var isButtonPressed


# Called when the node enters the scene tree for the first time.
func _ready():
	isButtonPressed = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	print(body)
	if (body == get_node("../Boss")):
		isButtonPressed = true
		print('le bouton a été appuyé par le boss')
