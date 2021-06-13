extends Enemy


class_name Minecraft

var posrand=Vector2.ZERO
var dir=Vector2.ZERO
var timebfdash=randi()%5
var dashing = false


onready var anim_tree : AnimationTree = $AnimationTree
onready var sprite : Sprite = $Sprite
onready var spawn_min = get_node("/root/World1/spawn_references/spawn_min")
onready var spawn_max = get_node("/root/World1/spawn_references/spawn_max")
var timewallking=randi()%4

func _ready() -> void:
	posrand = get_random_position()
	MAX_HP = 100
	hp = MAX_HP
	$Timer.set_wait_time(randi()%9+randf())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dir = position.direction_to(posrand).normalized()
	
	if (!dashing):
		sprite.flip_h = (dir.x > 0)
	
	var is_moving = false
	if $Timer.time_left>timewallking:
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
#	dashing=true
#	anim_tree.set("parameters/move_state/current", 1)
#	var totaltime = 0
#	var direction = initdir
#	var collision = false
#	var acceleration = 1
#	while dashing:
#		var delta = get_process_delta_time()
#		var currentcollision = move_and_collide(direction * acceleration)
#		if currentcollision==null:
#			pass
#		else:
#			direction=currentcollision.normal
#			totaltime=0
#			collision = true
#		if !collision:
#			acceleration = (1+totaltime*totaltime) * move_speed * 3 * delta
#		else:
#			acceleration = acceleration/1.2
#		totaltime+=delta
#		if (totaltime>=0.8) || (collision&&totaltime>=0.2):
#			dashing=false
#		yield(get_tree(), "idle_frame")
#	anim_tree.set("parameters/move_state/current", 0)
	pass

func _on_Timer_timeout():
	posrand=get_random_position()
	timebfdash-=1
	timewallking=randi()%4+randf()
	$Timer.set_wait_time(randi()%9+randf())
	if timebfdash <= 0:
		timebfdash = randi()%5
		dash(dir.normalized())
