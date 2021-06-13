extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var boss = get_node("YSort/Boss")
var delta_counter = 0
onready var zombie_scn = load("res://scenes/Zombie.tscn")
onready var rafale_zombie_script = load("res://scenes/Rafale.gd")

var enemies_alive = []


onready var spawn_min = get_node("positionReference/min_spawn")
onready var spawn_max = get_node("positionReference/max_spawn")

onready var player_node = get_node("YSort/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("YSort/Player").main_node = self
	spawn_enemy()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(boss.phase)
	delta_counter += delta
	
	var array_range = enemies_alive.size()
	var alive_enemies = []
	for i in range(array_range) :
		if (is_instance_valid(enemies_alive[i])):
			alive_enemies.append(enemies_alive[i])
	enemies_alive = alive_enemies
	
	if (boss.phase == 1):
		if (delta_counter >= 5):
			delta_counter -= 5
			if (enemies_alive.size()<5):
				spawn_enemy()
			
	if (boss.phase == 2 && boss.hp <= 0):
		get_tree().change_scene("res://scenes/bossStage.tscn")
		
func spawn_enemy():
	var instance = zombie_scn.instance()
	instance.set_script(rafale_zombie_script)
	instance.target = player_node
	instance.main_node = self
	instance.position = get_random_position_outside_of_player_view()
	enemies_alive.append(instance)
	add_child(instance)
		
func get_random_position_outside_of_player_view():
	var x_max = int(spawn_max.position.x)
	var x_min = int(spawn_min.position.x)
	var y_max = int(spawn_max.position.y)
	var y_min = int(spawn_min.position.y)
	
	var rand_pos = Vector2(randi()%(x_max - x_min) + x_min,randi()%(y_max - y_min) + y_min)
	
	# Pour éviter que le point spawn dans la vision du joueur
	while (get_viewport_rect().has_point(rand_pos)):
		rand_pos = Vector2(randi()%(x_max - x_min) + x_min,randi()%(y_max - y_min) + y_min)
	
	return rand_pos

	
#func _on_Area2D2_body_shape_entered(body_id, body, body_shape, local_shape):
#	print(body)
#	if (body == get_node("../Boss")):	
#		isButtonPressed = true
#		get_node("Sprite").texture = load("res://sprites/Bouton2.png")
#		get_node("../spikes").visible = true
#		get_node("../spikes2").visible = true
#		print('Le boss est sur le bouton')
