extends Node

class_name StateTracker

signal state_changed(state: String)

var triggered: bool = false
var parent

var state: String = "default":
	set(new_value):
		if state != new_value:
			state = new_value
			emit_signal("state_changed", state)


func _ready() -> void:
	_connect_state_changed_signal()


func _connect_state_changed_signal():
	if get_parent() is not Interactable2D:
		return
	parent = get_parent()
	connect("state_changed", Callable(parent, "_state_changed"))
	parent._register_state_tracker(self) 

func _flip_state():
	parent = get_parent()
	if parent.my_data.multi_interact == false and parent.my_data.triggered == true:
		print("THIS IS IT")
		return
	var states = parent.my_data.states
	var non_active_states: Array[String]
	for potential_state in states:
		if potential_state != state:
			non_active_states.append(potential_state)
	state = non_active_states[0]
	var id = parent.my_data.id
	parent.my_data.triggered = true
	SaveManager._import_change_to_save_data("InteractableData", id, "active_state", state)
	SaveManager._import_change_to_save_data("InteractableData", id, "triggered", true)
	print("THIS IS STATE: ", state)
