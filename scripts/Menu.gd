extends MarginContainer

class_name Menu

var is_enabled = true

var selectors = [
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

func set_selectors(selectors_array):
	selectors = selectors_array
	
func set_actions(actions_array):
	actions = actions_array

func _input(event):
	if not is_enabled: return
	
	if event.is_action_pressed("ui_up"):
		curr_selection -= 1
	if event.is_action_pressed("ui_down"):
		curr_selection += 1
	curr_selection = fposmod(curr_selection, selectors.size())
	
	if event.is_action_pressed("ui_accept"):
		actions[curr_selection].call_func()
	
	update_display()

func update_display():
	for idx in range(selectors.size()):
		selectors[idx].text = SELECTOR_TEXT if idx == curr_selection else ""
