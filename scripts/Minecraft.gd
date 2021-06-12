extends Enemy


class_name Minecraft

var posrand=Vector2.ZERO
var dir=Vector2.ZERO
var timebfdash=5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dir = position.direction_to(posrand).normalized()
	if $Timer.time_left>1.5:
		if timebfdash>0:
			move_and_collide(dir * move_speed * delta)	
	
	
func get_random_position():
	var x_max=get_viewport_rect().size.x
	var y_max=get_viewport_rect().size.y
	var xrand=randi()%int(x_max)
	var yrand=randi()%int(y_max)
	return Vector2(xrand,yrand)
	
func dash(initdir):
	var totaltime = 0
	while totaltime < 0.8:
		var delta = get_process_delta_time()
		move_and_collide(initdir * move_speed * 3 * delta)
		totaltime += delta
		yield(get_tree(), "idle_frame")

func _on_Timer_timeout():
	posrand=get_random_position()
	timebfdash-=1
	if timebfdash <= 0:
		timebfdash = 5
		dash(dir.normalized())


func _on_Timer_ready():
	posrand=get_random_position()
