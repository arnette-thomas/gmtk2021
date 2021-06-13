extends KinematicBody2D

class_name Enemy


var MAX_HP := 100.0
var hp : float

export(NodePath) var target_path = null
export var max_hook_range = 500
var target = null
export var move_speed = 100

const FRIENDLY := false
signal about_to_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = MAX_HP
	if target_path != null: target = get_node(target_path)


func remove_hp(amnt):
	hp -= amnt
	if (hp <= 0):
		# Dead
		emit_signal("about_to_free")
		queue_free()
	
