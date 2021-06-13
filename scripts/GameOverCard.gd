extends MarginContainer

onready var MENU_SCENE = preload("res://scenes/MainMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		on_enter_key()
	

func on_enter_key():
	get_tree().change_scene_to(MENU_SCENE)
