extends Menu

# Called when the node enters the scene tree for the first time.
func _ready():
	is_enabled = false
	set_selectors([
		$CenterContainer/VBoxContainer/VBoxContainer/ContinueContainer/ContinueSelection,
		$CenterContainer/VBoxContainer/VBoxContainer/OptionsContainer/OptionsSelection,
		$CenterContainer/VBoxContainer/VBoxContainer/ExitContainer/ExitSelection
	])
	set_actions([
		funcref(self, "on_continue"),
		funcref(self, "on_options"),
		funcref(self, "on_exit")
	])
	
	update_display()


func _input(event):
	if event.is_action_pressed("pause") || (is_enabled && event.is_action_pressed("ui_cancel")):
		toggle_pause()

func toggle_pause():
	is_enabled = !is_enabled
	get_tree().paused = is_enabled
	visible = is_enabled

### Menu actions

func on_continue():
	toggle_pause()
	
func on_options():
	pass
	
func on_exit():
	if is_enabled: toggle_pause()
	get_tree().change_scene("res://scenes/MainMenu.tscn")
