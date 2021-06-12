extends Enemy

class_name Zombie

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target == null: return
	
	var dir = position.direction_to(target.position).normalized()
	move_and_collide(dir * move_speed * delta)
