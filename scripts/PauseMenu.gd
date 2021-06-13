extends Menu

onready var options_text = $CenterContainer/VBoxContainer/VBoxContainer/OptionsContainer/OptionsLabel as Label
const MUTE_TEXT = "Mute"
const UNMUTE_TEXT = "Unmute"

var muted = false

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
	AudioManager.get_node("MusicStreamPlayer").stream_paused = muted

### Menu actions

func on_continue():
	toggle_pause()
	
func on_options():
	muted = !AudioManager.get_node("MusicStreamPlayer").stream_paused
	AudioManager.get_node("MusicStreamPlayer").stream_paused = muted
	options_text.text = MUTE_TEXT if !muted else UNMUTE_TEXT
	
func on_exit():
	if is_enabled: toggle_pause()
	get_tree().change_scene("res://scenes/MainMenu.tscn")
