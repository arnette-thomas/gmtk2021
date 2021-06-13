extends KinematicBody2D

class_name Enemy


var MAX_HP := 100.0
var hp : float

export(NodePath) var target_path = null
export var max_hook_range = 800
var target = null
export var move_speed = 100
var knockbacking=false

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
	
func knockback(vect):
	knockbacking = true
	var totaltime=0
	var delta = get_process_delta_time()
	while knockbacking:
		move_and_collide(vect)
		vect = vect/1.1
		totaltime+=delta
		if totaltime>=0.3:
			knockbacking=false
		yield(get_tree(), "idle_frame")
