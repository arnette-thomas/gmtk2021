extends Menu

onready var game_scene = preload("res://scenes/World1.tscn")

onready var main_canvas = $CenterContainer
onready var howto_canvas = $HowToCanvas
var howto_stage = 0
onready var howto_scenes = [
	$HowToCanvas/VBoxContainer/CenterContainer/VBoxContainer,
	$HowToCanvas/VBoxContainer/CenterContainer/VBoxContainer3,
	$HowToCanvas/VBoxContainer/CenterContainer/VBoxContainer2
]
var howto_request = true

onready var credits_canvas = $CreditsCanvas
var is_in_credits = false
var credits_request = false

var muted = false

const MUTE_TEXT = "Mute Music"
const UNMUTE_TEXT = "Unmute Music"

onready var options_text = $CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/MuteContainer/MuteLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	set_selectors([
		$CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/ContinueContainer/ContinueSelection,
		$CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/HowToContainer/HowToSelection,
		$CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/MuteContainer/MuteSelection,
		$CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/CreditsContainer/CreditsSelection,
		$CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/ExitContainer/ExitSelection
	])
	set_actions([
		funcref(self, "on_start"),
		funcref(self, "on_howto"),
		funcref(self, "on_mute"),
		funcref(self, "on_credits"),
		funcref(self, "on_exit")
	])
	
	update_display()

func _process(delta):
	if howto_stage > 0:
		for i in range(howto_scenes.size()):
			if i + 1 == howto_stage:
				howto_scenes[i].visible = true
			else:
				howto_scenes[i].visible = false
		
		if Input.is_action_just_pressed("ui_accept") && !howto_request:
			howto_stage += 1
			
		if howto_stage > howto_scenes.size():
			howto_stage = 0
			howto_canvas.visible = false
			main_canvas.visible = true
			is_enabled = true
			
		howto_request = false
		
	if is_in_credits && !is_enabled:
		if Input.is_action_just_pressed("ui_accept") && !credits_request:
			credits_canvas.visible = false
			main_canvas.visible = true
			is_enabled = true
			is_in_credits = false
		credits_request = false


func on_start():
	get_tree().change_scene_to(game_scene)

func on_howto():
	howto_canvas.visible = true
	main_canvas.visible = false
	is_enabled = false
	howto_stage = 1
	howto_request = true
	
func on_mute():
	muted = !AudioManager.get_node("MusicStreamPlayer").stream_paused
	AudioManager.get_node("MusicStreamPlayer").stream_paused = muted
	options_text.text = MUTE_TEXT if !muted else UNMUTE_TEXT

func on_credits():
	credits_canvas.visible = true
	main_canvas.visible = false
	is_enabled = false
	is_in_credits = true
	credits_request = true

func on_exit():
	get_tree().quit()
