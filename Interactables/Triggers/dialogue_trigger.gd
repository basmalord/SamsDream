extends Trigger

class_name DialogueTrigger

var player_body: Node
@export var dialogue_lines: Array[String] = ["Default Dialogue Text", "More Default Dialogue Text"]

func _enter_trigger(triggering_body):
	if !automatic_enter_trigger:
		interact_trigger_activated = false
		is_inside_area = true
		player_body = triggering_body
		return
	_start_dialogue()

func _exit_trigger(triggering_body):
	DialogueManager._hide_text_box()
	interact_trigger_activated = false
	is_inside_area = false
	my_interactable.get_child(0).shape.size = my_interactable.get_child(0).shape.size / 3

func _input_trigger(triggering_body):
	if automatic_enter_trigger:
		return
	if Input.is_action_just_pressed(interact_input):
		interact_trigger_activated = true
		_start_dialogue()

func _start_dialogue():
	DialogueManager.start_dialogue(dialogue_lines, my_interactable.get_child(0))
	my_interactable.get_child(0).shape.size = my_interactable.get_child(0).shape.size * 3

func _process(delta: float) -> void:
	if !is_inside_area or interact_trigger_activated:
		return
	_input_trigger(player_body)
