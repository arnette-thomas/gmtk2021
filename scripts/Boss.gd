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
	move_and_collide(dir * moveSpeed * delta)
	pass
	
func bossWaiting():
	pass
	
func bossDashing(delta):
	move_and_collide(dashDirection * dashSpeed * delta)
	pass
	

