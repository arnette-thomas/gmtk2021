extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MOVE_SPEED := 400
const MIN_MOVE_SPEED := 200
var dir := Vector2.ZERO
var dashing=false

onready var gun_visu := $GunVisu

const CAPTURE_RANGE = 150
var capture_curr_range = 0
const CAPTURE_GROW_SPEED = 100
const FRIENDLY := true
onready var chain := $Chain

onready var animation = $AnimationPlayer

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
	gun_visu.gun = current_gun

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Handle inputs
	var aim_dir = Vector2(Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"), Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up"))
	var shooting_dir = aim_dir if aim_dir != Vector2.ZERO else gun_visu.position.direction_to(get_local_mouse_position())
	gun_visu.target_position = shooting_dir
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if dir.length() > 1:
		dir = dir.normalized()
	
	# Move player, apply malus if chain tension
	var speed = lerp(MIN_MOVE_SPEED, MOVE_SPEED, 1 - chain.get_tension())
	if !dashing:
		move_and_collide(dir * speed * delta)
	
	# Play correct animation
	if dir != Vector2.ZERO:
		animation.play("run")
	else:
		animation.play("idle")
	
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
	if EnemyLinked is Minecraft:
		chain.break_chain()
		dash(gun_visu.target_position)
	elif EnemyLinked==null:
		pass
	else :
		fire_timer = current_gun.reload_time
#		var position_centered = position + Vector2.UP * 50
		var position_centered = gun_visu.get_node("Sprite/bout_du_gun").global_position
		gun_visu.fire()
		var bullets = current_gun.generate_bullets(position_centered, gun_visu.gun_position.normalized())
		for b in bullets:
			main_node.add_child(b)
	
#	if Input.is_action_just_pressed("ui_accept"):
#		Globals.camera.shake(100, 0.2, 400)

func change_weapon():
	if EnemyLinked is BasicZombie:
		current_gun_index=0
	elif EnemyLinked is shotgun:
		current_gun_index=1
	elif EnemyLinked is Rafale:
		current_gun_index=2
	elif EnemyLinked is Boulet_Unique:
		current_gun_index=3
	else :
		current_gun_index=4
	current_gun = guns[current_gun_index].new()
	current_gun.friendly = FRIENDLY		
	gun_visu.get_node("Sprite").texture = current_gun.image
	gun_visu.gun = current_gun

func _on_Chain_enemy_hooked(body):
	if body is Minecraft:
		EnemyLinked = body
	elif body is BasicZombie:
		EnemyLinked = body
	elif body is shotgun:
		EnemyLinked = body
	elif body is Rafale:
		EnemyLinked = body
	elif body is Boulet_Unique:
		EnemyLinked = body
	elif body is shotgun:
		EnemyLinked = body
	change_weapon()
	
	
func dash(initdir):
	dashing=true
	var totaltime = 0
	var direction = initdir
	var collision = false
	var acceleration = 1
	while dashing:
		var delta = get_process_delta_time()
		var currentcollision = move_and_collide(direction * acceleration)
		if currentcollision==null:
			pass
		else:
			direction=currentcollision.normal
			totaltime=0
			collision = true
			Globals.camera.shake(200, 0.1, 500)
		if !collision:
			acceleration = (1+totaltime*totaltime) * MOVE_SPEED * 3 * delta
		else:
			acceleration = acceleration/1.2
		totaltime+=delta
		if (totaltime>=0.4) || (collision&&totaltime>=0.2):
			dashing=false
		yield(get_tree(), "idle_frame")
	


func _on_Chain_chain_broken():
	EnemyLinked=null
	change_weapon()
