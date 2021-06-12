extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MOVE_SPEED := 400
const MIN_MOVE_SPEED := 200
var dir := Vector2.ZERO

onready var gun_visu := $GunVisu
onready var chain := $Chain

var main_node

var fire_timer := 0.0

var BasicGunClass := load("res://scripts/gun/Basic.gd")
var ShotgunClass := load("res://scripts/gun/Shotgun.gd")
var SniperClass := load("res://scripts/gun/Sniper.gd")
var EnergyGunClass := load("res://scripts/gun/EnergyGun.gd")
var guns := [BasicGunClass, ShotgunClass, SniperClass, EnergyGunClass]

var current_gun_index := 0
var current_gun : GunBase


# Called when the node enters the scene tree for the first time.
func _ready():
	current_gun = guns[current_gun_index].new()
	gun_visu.get_node("Sprite").texture = current_gun.image

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
	if Input.is_action_just_pressed("ui_focus_next"):
		current_gun_index += 1
		if current_gun_index == guns.size():
			current_gun_index = 0
		current_gun = guns[current_gun_index].new()
		gun_visu.get_node("Sprite").texture = current_gun.image
		

		
func fire():
	fire_timer = current_gun.reload_time
#	var position_centered = position + Vector2.UP * 50
	var position_centered = gun_visu.get_node("Sprite/bout_du_gun").global_position
	gun_visu.fire()
	var bullets = current_gun.generate_bullets(position_centered, gun_visu.gun_position.normalized())
	for b in bullets:
		main_node.add_child(b)
	
#	if Input.is_action_just_pressed("ui_accept"):
#		Globals.camera.shake(100, 0.2, 400)

func _on_Chain_chain_touched(body):
	pass # Replace with function body.
