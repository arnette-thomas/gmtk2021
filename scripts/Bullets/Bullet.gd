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
onready var fireParticles = $FireParticles

var friendly_sprite := load("res://sprites/bullet.png")
var evil_sprite := load("res://sprites/evil_bullet.png")

func setup(friendly_ : float):
	friendly = friendly_
	
# Called when the node enters the scene tree for the first time.
func _ready():
	particles.color_ramp = Gradient.new()
	fireParticles.color_ramp = Gradient.new()
	rotation = direction.angle()
	fireParticles.restart()
	flip = randi()%4
	if friendly:
		sprite.texture = friendly_sprite
		particles.color_ramp.set_color(0, Color("2fa09d"))
		particles.color_ramp.set_color(1, Color("043654"))
		fireParticles.color_ramp.set_color(0, Color("2fa09d"))
		fireParticles.color_ramp.set_color(1, Color("000000"))

	else:
		sprite.texture = evil_sprite
		particles.color_ramp.set_color(0, Color("fd301b"))
		particles.color_ramp.set_color(1, Color("6c1515"))
		fireParticles.color_ramp.set_color(0, Color("fd301b"))
		fireParticles.color_ramp.set_color(1, Color("000000"))



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
	if body.is_in_group("walls") or body.is_in_group("terrain"):
		particles.restart()
		$Sprite.visible = false
		speed = 0
		yield(get_tree().create_timer(particles.lifetime), "timeout")
		queue_free()
