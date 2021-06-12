extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var line = $Line
onready var coll = $CollisionShape2D
onready var animation = $AnimationPlayer

var is_shooting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	line.scale.x = 0
	coll.scale.x = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shoot_chain") && !is_shooting:
		var aim_dir = Vector2(Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"), Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up"))
		var shooting_dir = aim_dir if aim_dir != Vector2.ZERO else get_local_mouse_position().normalized()
		rotation = Vector2.RIGHT.angle_to(shooting_dir)
		animation.play("shoot")
		is_shooting = true


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "shoot":
		line.scale.x = 0
		coll.scale.x = 0
		rotation = 0
		is_shooting = false
