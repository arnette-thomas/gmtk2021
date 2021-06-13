extends Enemy

class_name Boss

var behaviourStage
# The current behaviour of the boss
# 1 --> is walking toward the player
# 2 --> is waiting (just before an attack)
# 3 --> is dashing toward the player (not homing)
# 4 --> is waiting (just after an attack)

var deltaCounter
var moveSpeed
var dashDirection
var dashSpeed

onready var anim_tree : AnimationTree = $AnimationTree
onready var sprite : Sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_viewport_rect().size / 2
	deltaCounter = 0
	behaviourStage = 0
	moveSpeed = 200
	dashSpeed = 1500
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deltaCounter += delta
	if target == null: return
	
	match behaviourStage:
		0:
			bossMoveTowardPlayer(delta)
			if (deltaCounter > 1) :
				deltaCounter -= 1
				behaviourStage = 1
				dashDirection = position.direction_to(get_node("../Player").position).normalized()
		1:
			bossWaiting()
			anim_tree.set("parameters/move_state/current", 1)
			anim_tree.set("parameters/idle_state/current", 1)
			if (deltaCounter > 1) :
				deltaCounter -= 1
				behaviourStage = 2
		2:
			bossDashing(delta)
			if (move_and_collide(dashDirection * moveSpeed * delta,  true, true, true)):
				deltaCounter = 0
				behaviourStage = 3
		3:
			bossWaiting()
			if (deltaCounter > 1) :
				deltaCounter -= 1
				behaviourStage = 0

	pass
	
func bossMoveTowardPlayer(delta):
	var dir = position.direction_to(target.position).normalized()
	sprite.flip_h = dir.x > 0
	move_and_collide(dir * moveSpeed * delta)
	anim_tree.set("parameters/move_state/current", 0)
	anim_tree.set("parameters/idle_state/current", 1)
	pass
	
func bossWaiting():
	anim_tree.set("parameters/idle_state/current", 0)
	
func bossDashing(delta):
	sprite.flip_h = dashDirection.x > 0
	move_and_collide(dashDirection * dashSpeed * delta)
	pass

func _on_Area2D_body_shape_entered(body_id, body, body_shape, local_shape):
	print('Boss on button')
	pass # Replace with function body.
