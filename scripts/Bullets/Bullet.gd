extends Node2D

var speed : float

var direction : Vector2

var flip := 0
var friendly : float

onready var sprite := $Sprite
onready var particles = $Particles2D
onready var fireParticles = $FireParticles

var friendly_sprite := load("res://sprites/bullet.png")
var evil_sprite := load("res://sprites/evil_bullet.png")
var can_hit := true  # When false, collision logic is disabled

var damage: float

func setup(friendly_ : float, damage_: float):
	friendly = friendly_
	damage = damage_
	
# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = direction.angle()
	fireParticles.restart()
	flip = randi()%4
	if friendly:
		sprite.texture = friendly_sprite
	else:
		sprite.texture = evil_sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * delta * speed
	
	# Au cas où on sorte de l'écran
	if position.x > 15000 or position.x < -15000 or \
		position.y > 15000 or position.y < -15000:
		queue_free()
	
	# flip pour une pseudo animation
	sprite.set_flip_v(flip<2)
	flip += 1
	if flip == 4:
		flip = 0


func _on_Area2D_body_entered(body):
	if (not can_hit):
		return
		 
	if body.is_in_group("walls") or body.is_in_group("terrain"):
		do_the_particle_thingy_then_kill()
		
	elif body.is_in_group("enemies") and friendly:
		body.remove_hp(damage)
		do_the_particle_thingy_then_kill()


func do_the_particle_thingy_then_kill():
	# Disable collisions
	can_hit = false
	
	# Play explosion
	particles.restart()
	$Sprite.visible = false
	speed = 0
	yield(get_tree().create_timer(particles.lifetime), "timeout")
	queue_free()
