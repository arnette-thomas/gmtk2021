extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed : float

var direction : Vector2

onready var particles = $Particles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = direction.angle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * delta * speed
	
	# Au cas où on sorte de l'écran
	if position.x > 15000 or position.x < -15000 or \
		position.y > 15000 or position.y < -15000:
		queue_free()
	


func _on_Area2D_body_entered(body):
	if body.is_in_group("walls"):
		particles.restart()
		$Sprite.visible = false
		speed = 0
		yield(get_tree().create_timer(particles.lifetime), "timeout")
		queue_free()
