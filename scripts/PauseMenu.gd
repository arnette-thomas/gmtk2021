extends MarginContainer

var is_enabled = false

onready var selectors = [
	$CenterContainer/VBoxContainer/VBoxContainer/ContinueContainer/ContinueSelection,
	$CenterContainer/VBoxContainer/VBoxContainer/OptionsContainer/OptionsSelection,
	$CenterContainer/VBoxContainer/VBoxContainer/ExitContainer/ExitSelection
]

var actions = [
	funcref(self, "on_continue"),
	funcref(self, "on_options"),
	funcref(self, "on_exit")
]

const SELECTOR_TEXT = ">"
var curr_selection = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	update_display()


func _input(event):
	if event.is_action_pressed("pause") || (is_enabled && event.is_action_pressed("ui_cancel")):
		toggle_pause()
	
	if not is_enabled: return
	
	if event.is_action_pressed("up") || event.is_action_pressed("ui_up"):
		curr_selection -= 1
	if event.is_action_pressed("down") || event.is_action_pressed("ui_down"):
		curr_selection += 1
	curr_selection = fposmod(curr_selection, selectors.size())
	
	if event.is_action_pressed("ui_accept"):
		actions[curr_selection].call_func()
	
	update_display()
	
func update_display():
	for idx in range(selectors.size()):
		selectors[idx].text = SELECTOR_TEXT if idx == curr_selection else ""

func toggle_pause():
	is_enabled = !is_enabled
	visible = is_enabled
	get_tree().paused = is_enabled

### Menu actions

func on_continue():
	toggle_pause()
	
func on_options():
	pass
	
func on_exit():
	get_tree().quit()
