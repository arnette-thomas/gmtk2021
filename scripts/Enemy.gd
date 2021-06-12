extends KinematicBody2D

class_name Enemy

export(NodePath) var target_path = null
export var max_hook_range = 500
var target = null
export var move_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	if target_path != null: target = get_node(target_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
