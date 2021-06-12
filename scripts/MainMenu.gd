extends Menu

onready var game_scene = preload("res://scenes/World1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_selectors([
		$CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/ContinueContainer/ContinueSelection,
		$CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/ExitContainer/ExitSelection
	])
	set_actions([
		funcref(self, "on_start"),
		funcref(self, "on_exit")
	])
	
	update_display()

func on_start():
	get_tree().change_scene_to(game_scene)
	
func on_exit():
	get_tree().quit()
