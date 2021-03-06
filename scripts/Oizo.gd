extends Enemy


class_name Oizo

var posrand=Vector2.ZERO
var dir=Vector2.ZERO

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
	move_and_collide(dir * move_speed * delta)
	
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




func _on_Timer_timeout():
	posrand=get_random_position()
