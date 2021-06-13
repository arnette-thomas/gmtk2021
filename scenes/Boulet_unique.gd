extends Zombie

class_name Boulet_Unique


var delta_counter = 0

var is_in_rafale = false
var rafale_iterator = 0
const rafale_number = 1
const time_between_rafale = 0.2

const reload_time = 3

const rafale_move_speed = 100

var EGunClass := load("res://scripts/gun/EnergyGun.gd")


# Called when the node enters the scene tree for the first time.
func _ready():
	move_speed = rafale_move_speed
	current_gun = EGunClass.new()
	gun_visu.get_node("Sprite").texture = current_gun.image
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta_counter += delta
	if (is_in_rafale == false):
		if (delta_counter < reload_time):
			move_speed = rafale_move_speed * (1 - delta_counter/reload_time)
		else:
			is_in_rafale = true
			rafale_iterator = 1
			delta_counter -= reload_time
			fire()
	
		
	if (is_in_rafale == true && delta_counter > time_between_rafale):
		delta_counter -= time_between_rafale
		if (rafale_iterator == rafale_number):
			is_in_rafale = false
			rafale_iterator = 0
			move_speed = rafale_move_speed
		else :
			rafale_iterator += 1
			fire()
		
		
		
