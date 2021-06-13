extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed : float

var direction : Vector2

var flip := 0
var friendly : float

onready var sprite := $Sprite
onready var particles = $Particles2D
onready var particles_continue = $ParticulesContinu

var friendly_sprite := load("res://sprites/GrosseBouboule.png")
var evil_sprite := load("res://sprites/evil_GrosseBouboule.png")
var damage: float

var can_hit := true

func setup(friendly_ : float, damage_):
	friendly = friendly_
	damage = damage_

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = direction.angle()
	particles.color_ramp = Gradient.new()
	particles_continue.color_ramp = Gradient.new()
	flip = randi()%4
	if friendly:
		sprite.texture = friendly_sprite
		
		particles.color_ramp.set_color(0, Color("2fa09d"))
		particles.color_ramp.set_color(1, Color("043654"))
		
		particles_continue.color_ramp.set_color(0, Color("2fa09d"))
		particles_continue.color_ramp.set_color(1, Color("7c043654"))

	else:
		sprite.texture = evil_sprite
		
		particles.color_ramp.set_color(0, Color("fd301b"))
		particles.color_ramp.set_color(1, Color("6c1515"))
		
		particles_continue.color_ramp.set_color(0, Color("fd301b"))
		particles_continue.color_ramp.set_color(1, Color("7c6c1515"))
		
		speed *= 0.7
		
	particles_continue.restart()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * delta * speed
	
	# Au cas où on sorte de l'écran
	if position.x > 15000 or position.x < -15000 or \
		position.y > 15000 or position.y < -15000:
		queue_free()
	


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
	particles_continue.one_shot = true
	particles.restart()
	$Sprite.visible = false
	speed = 0
	yield(get_tree().create_timer(particles.lifetime), "timeout")
	queue_free()
