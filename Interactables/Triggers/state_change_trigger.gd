extends Trigger

class_name StateChangeTrigger

var player_body: Node


func _enter_trigger(triggering_body):
	if !automatic_enter_trigger:
		interact_trigger_activated = false
		is_inside_area = true
		player_body = triggering_body.get_parent()
		return
	player_body = triggering_body.get_parent()



func _exit_trigger(triggering_body):
	pass

func _input_trigger(triggering_body):
	if automatic_enter_trigger:
		return
	if Input.is_action_just_pressed(interact_input):
		interact_trigger_activated = true
		_alter_state_trigger()

func _alter_state_trigger():
	my_interactable = get_parent()
	my_interactable.state_tracker._flip_state()



func _process(delta: float) -> void:
	if !is_inside_area or interact_trigger_activated:
		return
	_input_trigger(player_body)
