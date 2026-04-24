extends Trigger

class_name InteractiveDialogueTrigger

@export var output_line: OutputLine

var player_body: Node

#func _enter_trigger(triggering_body):
	#print("inside")
	#if !automatic_enter_trigger:
		#interact_trigger_activated = false
		#is_inside_area = true
		#player_body = triggering_body.get_parent()
		#print("WORKING S 1")
		#return
	#player_body.interactive_dialogue.show()
	#print("BLAAAAH")
#
#
#func _input_trigger(triggering_body):
	#print("input trigger firing")
	#if automatic_enter_trigger:
		#return
	#if Input.is_action_just_pressed(interact_input):
		#interact_trigger_activated = true
		#player_body.interactive_dialogue.show()
		#print("WORKING S2")
func _enter_trigger(triggering_body):
	if !automatic_enter_trigger:
		interact_trigger_activated = false
		is_inside_area = true
		player_body = triggering_body.get_parent()
		return
	player_body = triggering_body.get_parent()
	player_body.interactive_dialogue.show()
	_start_dialogue()


func _exit_trigger(triggering_body):
	pass

func _input_trigger(triggering_body):
	if automatic_enter_trigger:
		return
	if Input.is_action_just_pressed(interact_input):
		interact_trigger_activated = true
		_start_dialogue()

func _start_dialogue():
	player_body.interactive_dialogue.show()
	player_body.interactive_dialogue.setup_from_output_line_resource(output_line)

func _process(delta: float) -> void:
	if !is_inside_area or interact_trigger_activated:
		return
	_input_trigger(player_body)
