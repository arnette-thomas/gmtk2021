extends Enemy


class_name Minecraft

var posrand=Vector2(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = position.direction_to(posrand).normalized()
	if $Timer.time_left>1.5:
		move_and_collide(dir * move_speed * delta)	
	
	
func get_random_position():
	var x_max=get_viewport_rect().size.x
	var y_max=get_viewport_rect().size.y
	var xrand=randi()%int(x_max)
	var yrand=randi()%int(y_max)
	return Vector2(xrand,yrand)

func _on_Timer_timeout():
	posrand=get_random_position()


func _on_Timer_ready():
	posrand=get_random_position()
