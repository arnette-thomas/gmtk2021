extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MOVE_SPEED := 400
const MIN_MOVE_SPEED := 200
var dir := Vector2.ZERO

onready var gun_visu := $GunVisu

const CAPTURE_RANGE = 150
var capture_curr_range = 0
const CAPTURE_GROW_SPEED = 100
const FRIENDLY := true
onready var chain := $Chain

var main_node

var fire_timer := 0.0

var BasicGunClass := load("res://scripts/gun/Basic.gd")
var ShotgunClass := load("res://scripts/gun/Shotgun.gd")
var SniperClass := load("res://scripts/gun/Sniper.gd")
var EnergyGunClass := load("res://scripts/gun/EnergyGun.gd")
var MagicWand := load("res://scripts/gun/MagicWand.gd")
var guns := [BasicGunClass, ShotgunClass, SniperClass, EnergyGunClass, MagicWand]

var current_gun_index := 4
var current_gun : GunBase
var EnemyLinked


# Called when the node enters the scene tree for the first time.
func _ready():
	current_gun = guns[current_gun_index].new()
	gun_visu.get_node("Sprite").texture = current_gun.image
	current_gun.friendly = FRIENDLY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Handle inputs
	
	gun_visu.target_position = get_local_mouse_position().normalized()
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if dir.length() > 1:
		dir = dir.normalized()
	
	# Move player, apply malus if chain tension
	var speed = lerp(MIN_MOVE_SPEED, MOVE_SPEED, 1 - chain.get_tension())
	move_and_collide(dir * speed * delta)
	
	# fire
	fire_timer -= delta
	if Input.is_action_pressed("fire_bullet") and fire_timer < 0:
		fire()
		
	# change gun
#	if Input.is_action_just_pressed("ui_focus_next"):
#		current_gun_index += 1
#		if current_gun_index == guns.size():
#			current_gun_index = 0
#		current_gun = guns[current_gun_index].new()
#		current_gun.friendly = FRIENDLY		
#		gun_visu.get_node("Sprite").texture = current_gun.image
		

		
func fire():
	if EnemyLinked==Minecraft:
		dash(dir)
	elif EnemyLinked==null:
		pass
	else :
		fire_timer = current_gun.reload_time
#		var position_centered = position + Vector2.UP * 50
		var position_centered = gun_visu.get_node("Sprite/bout_du_gun").global_position
		gun_visu.fire()
		var bullets = current_gun.generate_bullets(position_centered, position_centered.direction_to(get_global_mouse_position()))
		for b in bullets:
			main_node.add_child(b)
	
#	if Input.is_action_just_pressed("ui_accept"):
#		Globals.camera.shake(100, 0.2, 400)

func change_weapon():
	if EnemyLinked==BasicZombie:
		current_gun_index=0
	if EnemyLinked==Rafale:
		current_gun_index=2
	if EnemyLinked==Boulet_Unique:
		current_gun_index=3
	if EnemyLinked==null:
		current_gun_index=4
	current_gun = guns[current_gun_index].new()
	current_gun.friendly = FRIENDLY		
	gun_visu.get_node("Sprite").texture = current_gun.image

func _on_Chain_enemy_hooked(body):
	if body is Minecraft:
		EnemyLinked=Minecraft
	if body is BasicZombie:
		EnemyLinked=BasicZombie
	if body is Rafale:
		EnemyLinked=Rafale
	if body is Boulet_Unique:
		EnemyLinked=Boulet_Unique
	change_weapon()
	
	
func dash(initdir):
	var totaltime = 0
	while totaltime < 0.2:
		var delta = get_process_delta_time()
		move_and_collide(get_local_mouse_position().normalized() * MOVE_SPEED * 3 * delta)
		totaltime += delta
		yield(get_tree(), "idle_frame")
	


func _on_Chain_chain_broken():
	EnemyLinked=null
	change_weapon()
