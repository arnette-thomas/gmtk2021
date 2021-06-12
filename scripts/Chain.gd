extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var line = $Line
onready var coll = $CollisionShape2D
onready var animation = $AnimationPlayer

signal enemy_hooked(body)

var is_shooting = false
var hooked_enemy : Enemy = null
onready var default_line_end = line.points[1]

# Called when the node enters the scene tree for the first time.
func _ready():
	line.scale.x = 0
	coll.scale.x = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# If there is an enemy hooked 
	if hooked_enemy != null:
		line.points[1] = line.to_local(hooked_enemy.position)
		
		# Chain break !
		if (line.points[1] - line.points[0]).length() > hooked_enemy.max_hook_range:
			hooked_enemy = null
			line.scale.x = 0
			coll.scale.x = 0
			line.points[1] = default_line_end
			print(line.points[1])
		return
		
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


func _on_Chain_body_entered(body: PhysicsBody2D):
	if body is Enemy:
		animation.stop()
		hooked_enemy = body
		line.scale.x = 1
		coll.scale.x = 1
		rotation = 0
		emit_signal("enemy_hooked", body as Enemy)
		is_shooting = false
