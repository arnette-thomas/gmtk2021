extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MOVE_SPEED := 400
var dir := Vector2.ZERO

const CAPTURE_RANGE = 150
var capture_curr_range = 0
const CAPTURE_GROW_SPEED = 100

var fire_timer :=0.0

var BasicGunClass := load("res://scripts/gun/Basic.gd")
var ShotgunClass := load("res://scripts/gun/Shotgun.gd")
var SniperClass := load("res://scripts/gun/Sniper.gd")
var current_gun : GunBase


# Called when the node enters the scene tree for the first time.
func _ready():
	current_gun = ShotgunClass.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Handle inputs
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if dir.length() > 1:
		dir = dir.normalized()
	
	# Move player
	move_and_collide(dir * MOVE_SPEED * delta)
	
	# fire
	fire_timer -= delta
	if Input.is_action_pressed("fire_bullet") and fire_timer < 0:
		fire()
		
func fire():
	fire_timer = current_gun.reload_time
	var position_centered = position + Vector2.UP * 50
	var bullets = current_gun.generate_bullets(position_centered, position_centered.direction_to(get_global_mouse_position()))
	for b in bullets:
		get_node("/root/World1").add_child(b)
	
