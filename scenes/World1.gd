extends Node2D

var enemies_alive_array = []
var enemies_list = []

# the position are absolute to the terrain
class Wave:
	var num_vaches: int
	var num_z_basic: int
	var num_z_rafales: int
	var num_z_boulet: int
	var num_z_shotgun: int

	func _init(nv: int, nzba: int, nzra: int, nzbo: int, nzsh: int):
		num_vaches = nv
		num_z_basic = nzba
		num_z_rafales = nzra
		num_z_boulet = nzbo
		num_z_shotgun = nzsh

var waves = [
	Wave.new(10,10,10,10,10),
	Wave.new(10,0,0,0,0),
]

var current_wave = 0

var zombie_scn = load("res://scenes/Zombie.tscn")
var minecraft_scn = load("res://scenes/Minecraft.tscn")

var basic_zombie_script = load("res://scenes/BasicZombie.gd")
var rafale_zombie_script = load("res://scenes/Rafale.gd")
var boulet_unique_zombie_script = load("res://scenes/Boulet_unique.gd")
var shotgun_zombie_script = load("res://scenes/Shotgun.gd")

onready var spawn_min = get_node("spawn_references/spawn_min")
onready var spawn_max = get_node("spawn_references/spawn_max")
onready var player_node = get_node("YSort/Player")
onready var player_camera_node = get_node("YSort/Player/Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("YSort/Player").main_node = self

	for wave in waves:
		var wave_list = []
		for vache in range(wave.num_vaches):
			wave_list.append('minecraft')
		for vache in range(wave.num_z_basic):
			wave_list.append('basic_zombie')
		for vache in range(wave.num_z_rafales):
			wave_list.append('rafale_zombie')
		for vache in range(wave.num_z_boulet):
			wave_list.append('boulet_unique_zombie')
		for vache in range(wave.num_z_shotgun):
			wave_list.append('shotgun_zombie')
		enemies_list.append(wave_list)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func return_according_instance(class_name_str, given_position):
	var instance
	match class_name_str :
		'minecraft':
			instance = minecraft_scn.instance()
			continue
		'basic_zombie':
			instance = zombie_scn.instance()
			instance.set_script(basic_zombie_script)
			instance.target = get_node("YSort/Player")
			instance.main_node = self
			continue
		'rafale_zombie':
			instance = zombie_scn.instance()
			instance.set_script(rafale_zombie_script)
			instance.target = get_node("YSort/Player")
			instance.main_node = self
			continue
		'shotgun_zombie':
			instance = zombie_scn.instance()
			instance.set_script(rafale_zombie_script)
			instance.target = get_node("YSort/Player")
			instance.main_node = self
			continue
		'boulet_unique_zombie':
			instance = zombie_scn.instance()
			instance.set_script(boulet_unique_zombie_script)
			instance.target = get_node("YSort/Player")
			instance.main_node = self
			continue
		_:
			var instance_position
			if 'x' in given_position :
				instance_position = spawn_min.position + Vector2(given_position.x, given_position.y)
			elif given_position == 'random' :
				instance_position = get_random_position_outside_of_player_view()
			instance.position = instance_position
	return instance
	
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


func _on_Timer_timeout():
	var array_range = enemies_alive_array.size()
	for i in range(array_range) :
		if (!is_instance_valid(enemies_alive_array[i])):
			enemies_alive_array.remove(i)
			i -= 1
			
	if enemies_alive_array == [] :
		for ennemy_name in enemies_list[current_wave] :
			var enemy_instance = return_according_instance(ennemy_name, 'random')
			enemies_alive_array.append(enemy_instance)
			add_child(enemy_instance)
		current_wave += 1
