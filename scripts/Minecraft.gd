extends Enemy


class_name Minecraft

var posrand=Vector2.ZERO
var dir=Vector2.ZERO
var timebfdash=5
var is_dashing = false

onready var anim_tree : AnimationTree = $AnimationTree
onready var sprite : Sprite = $Sprite
onready var spawn_min = get_node("/root/World1/spawn_references/spawn_min")
onready var spawn_max = get_node("/root/World1/spawn_references/spawn_max")

func _ready() -> void:
	posrand = get_random_position()
	MAX_HP = 1.0
	hp = MAX_HP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dir = position.direction_to(posrand).normalized()
	
	if (!is_dashing):
		sprite.flip_h = (dir.x > 0)
	
	var is_moving = false
	if $Timer.time_left>1.5:
		if timebfdash>0:
			move_and_collide(dir * move_speed * delta)
			is_moving = true
	
	if is_moving:
		anim_tree.set("parameters/idle_state/current", 1)
	else:
		anim_tree.set("parameters/idle_state/current", 0)
	
# Ancienne fonction
#func get_random_position():
#	var x_max=get_viewport_rect().size.x
#	var y_max=get_viewport_rect().size.y
#	var xrand=randi()%int(x_max)
#	var yrand=randi()%int(y_max)
#	return Vector2(xrand,yrand)

#Nouvelle fonction
func get_random_position():
	var x_max = int(spawn_max.position.x)
	var x_min = int(spawn_min.position.x)
	var y_max = int(spawn_max.position.y)
	var y_min = int(spawn_min.position.y)
	
	return Vector2(randi()%(x_max - x_min) + x_min,randi()%(y_max - y_min) + y_min)


func dash(initdir):
	is_dashing = true
	anim_tree.set("parameters/move_state/current", 1)
	var totaltime = 0
	while totaltime < 0.8:
		var delta = get_process_delta_time()
		move_and_collide(initdir * move_speed * 3 * delta)
		totaltime += delta
		yield(get_tree(), "idle_frame")
	anim_tree.set("parameters/move_state/current", 0)
	is_dashing = false

func _on_Timer_timeout():
	posrand=get_random_position()
	timebfdash-=1
	if timebfdash <= 0:
		timebfdash = 5
		dash(dir.normalized())
