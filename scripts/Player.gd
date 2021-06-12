extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MOVE_SPEED := 400
var dir := Vector2.ZERO

const CAPTURE_RANGE = 150
var capture_curr_range = 0
const CAPTURE_GROW_SPEED = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Handle inputs
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if dir.length() > 1:
		dir = dir.normalized()
	
	# Move player
	move_and_collide(dir * MOVE_SPEED * delta)
