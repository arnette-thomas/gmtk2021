extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var line = $Line
onready var coll = $CollisionShape2D
onready var animation = $AnimationPlayer
onready var particles = $Particles2D

signal enemy_hooked(body)
signal chain_broken()

var is_shooting = false
var hooked_enemy : Enemy = null
onready var default_line_end = line.points[1]
onready var default_line_width = line.width

var pulling = false

const MIN_WIDTH = 2
const MAX_WIDTH = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	line.scale.x = 0
	coll.scale.x = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coll.disabled = !is_shooting
	
	# If there is an enemy hooked 
	if hooked_enemy != null:
		line.points[1] = line.to_local(hooked_enemy.position)
		
		var line_length = (line.points[1] - line.points[0]).length()
		line.width = lerp(MAX_WIDTH, MIN_WIDTH, (to_local(hooked_enemy.position) - position).length() / hooked_enemy.max_hook_range)
		
		# Chain break !
		if line_length > hooked_enemy.max_hook_range && !pulling:
			break_chain()
		
	if Input.is_action_just_pressed("shoot_chain"):
		# Destroy chain if an enemy is already hooked
		if hooked_enemy != null:
			break_chain()
		
		# Shoot chain if not shooting
		elif !is_shooting:
			var aim_dir = Vector2(Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"), Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up"))
			var shooting_dir = aim_dir if aim_dir != Vector2.ZERO else get_local_mouse_position().normalized()
#			var shooting_dir = get_local_mouse_position().normalized()
			rotation = Vector2.RIGHT.angle_to(shooting_dir)
			animation.play("shoot")
			AudioManager.SFX.play("ChainShoot")
			is_shooting = true

	elif is_shooting:
		var aim_dir = Vector2(Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"), Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up"))
		var shooting_dir = aim_dir if aim_dir != Vector2.ZERO else get_local_mouse_position().normalized()
#			var shooting_dir = get_local_mouse_position().normalized()
		if aim_dir == Vector2.ZERO:
			rotation += Vector2.RIGHT.angle_to(shooting_dir)
		else:
			rotation = Vector2.RIGHT.angle_to(shooting_dir)
	
		

func break_chain():
	if (hooked_enemy.is_connected("about_to_free", self, "on_hooked_enemy_free")):
		hooked_enemy.disconnect("about_to_free", self, "on_hooked_enemy_free")
	hooked_enemy = null
	line.scale.x = 0
	coll.scale.x = 0
	line.points[1] = default_line_end
	line.width = default_line_width
	
	var coroutine = FreezeFrame.freeze(0.12)
	yield(coroutine, "completed")
	
	Globals.camera.shake(300, 0.1, 300)
	
	# particles
	spawn_destroy_particles()
	
	emit_signal("chain_broken")
	AudioManager.SFX.play("ChainBroken")

func get_tension():
	if hooked_enemy == null: 
		return 0.0
	return (to_local(hooked_enemy.position) - position).length() / hooked_enemy.max_hook_range

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
		hooked_enemy.connect("about_to_free", self, "on_hooked_enemy_free")
		line.scale.x = 1
		coll.scale.x = 1
		rotation = 0
		emit_signal("enemy_hooked", body as Enemy)
		AudioManager.SFX.play("ChainHit")
		is_shooting = false
		
		# Attract enemy if not enough range
		var diff = position - to_local(body.position)
		while diff.length() > (body.max_hook_range * 0.75):
			pulling = true
			body.move_and_collide(diff.normalized() * 1000 * get_process_delta_time())
			yield(get_tree(), "idle_frame")
			diff = position - to_local(body.position)
		pulling = false
		
	elif body.is_in_group("walls"):
		spawn_destroy_particles()
		animation.stop()
		line.scale.x = 0
		coll.scale.x = 0
		rotation = 0
		is_shooting = false

func spawn_destroy_particles():
	var line_vector = line.points[1] - line.points[0]
	line_vector.x *= line.scale.x
	line_vector.y *= line.scale.y
	line_vector = line_vector.rotated(rotation)
	var line_length = line_vector.length()
	particles.emission_rect_extents.x = line_length / 2.0
	particles.position = line_vector / 2.0
	particles.rotation = Vector2.RIGHT.angle_to(line_vector)
	particles.restart()

func on_hooked_enemy_free():
	break_chain()
