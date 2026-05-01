extends Node

class_name PlayerInputManager

var my_player: Node
var current_pressed_inputs: Array[String] = []
var input_state: String = "world"

signal inputs_changed
signal world_state_entered
signal ui_state_entered

func _ready():
	await get_tree().create_timer(0.5).timeout
	my_player.interactive_dialogue.connect("visibility_changed",Callable(self,"_change_input_state"))
	connect("inputs_changed", Callable(my_player.behaviour_manager.animation_manager, "_set_animation_speed"))


func _change_input_state():
	if input_state == "world":
		input_state = "ui"
		emit_signal("ui_state_entered")
		current_pressed_inputs = []
	elif input_state == "ui":
		input_state = "world"
		emit_signal("world_state_entered")
		current_pressed_inputs = []


func _input(event: InputEvent) -> void:
	if event is not InputEventKey:
		return
	var actions = InputMap.get_actions()
	if input_state == "world":
		for action in actions:
			if event.is_action_pressed(action):
				current_pressed_inputs.append(action)
				emit_signal("inputs_changed")
			if event.is_action_released(action):
				current_pressed_inputs.erase(action)
				emit_signal("inputs_changed")




func _on_resource_changed(test1,test2,test3,test4,test5):
	SaveManager._import_change_to_save_data(test1,test2,test3,test4,test5)
