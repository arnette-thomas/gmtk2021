extends Enemy

class_name Zombie

var BasicGunClass := load("res://scripts/gun/Basic.gd")
onready var animation := $AnimationPlayer

var current_gun
var fire_timer := 0.0
onready var gun_visu := $GunVisu


var main_node

func _ready():
	hp = MAX_HP
	if current_gun == null:
		current_gun = BasicGunClass.new()
		current_gun.friendly = FRIENDLY
		gun_visu.get_node("Sprite").texture = current_gun.image_evil
		gun_visu.setup(FRIENDLY)
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if target == null: return
	gun_visu.target_position = (target.position - position).normalized()
	
	var dir = position.direction_to(target.position).normalized()
	move_and_collide(dir * move_speed * delta)

	if dir != Vector2.ZERO && move_speed > 10:
		animation.play("run")
	else:
		animation.play("idle")

func fire():
	fire_timer = current_gun.reload_time
	var position_centered = gun_visu.get_node("Sprite/bout_du_gun").global_position
	gun_visu.fire()
	var bullets = current_gun.generate_bullets(position_centered, position_centered.direction_to(target.position))
	for b in bullets:
		main_node.add_child(b)


func remove_hp(amnt):
	.remove_hp(amnt)
	# Update Hp bar
	$HP_bar.show()
	$HP_bg.show()
	$HP_bar.rect_size.x = (hp as float / MAX_HP) * $HP_bg.rect_size.x
