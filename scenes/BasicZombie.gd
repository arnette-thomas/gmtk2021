extends Zombie

class_name BasicZombie

var delta_counter = rand_range(0, 01)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta_counter += delta
	if (delta_counter > 1):
		delta_counter -= 1
		fire()
