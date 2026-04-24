extends Trigger

class_name ChangeSceneTrigger

var player_body: Node
@export var delay_time: float = 0.0
@export var scene_to_make_active: PackedScene
#behaviour needs to be: move x distance towards a door or entrance, go through (some animation), then play transition, then change scene

func _enter_trigger(triggering_body):
	if !automatic_enter_trigger:
		interact_trigger_activated = false
		is_inside_area = true
		player_body = triggering_body.get_parent()
		return
	player_body = triggering_body.get_parent()
	player_body.interactive_dialogue.show()
	_trigger_change_scene()

func _exit_trigger(triggering_body):
	pass

func _input_trigger(triggering_body):
	if automatic_enter_trigger:
		return
	if Input.is_action_just_pressed(interact_input):
		interact_trigger_activated = true
		_trigger_change_scene()

func _process(delta: float) -> void:
	if !is_inside_area or interact_trigger_activated:
		return
	_input_trigger(player_body)

func _trigger_change_scene():
	await get_tree().create_timer(delay_time).timeout
	get_tree().change_scene_to_packed(scene_to_make_active)
