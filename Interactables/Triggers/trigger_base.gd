extends Node

class_name Trigger

var is_inside_area: bool = false
var interact_trigger_activated: bool = false
var my_interactable: Area2D
@export_enum("MOVE_FORWARD", "MOVE_BACKWARDS", "MOVE_LEFT", "MOVE_RIGHT", "SPRINT", "ADVANCE_DIALOGUE") var interact_input: String = "ADVANCE_DIALOGUE"
@export var automatic_enter_trigger: bool = true



func _ready():
	if get_parent() is not Area2D:
		return
	my_interactable = get_parent()
	my_interactable.area_entered.connect(_enter_trigger)
	my_interactable.area_exited.connect(_exit_trigger)
	my_interactable.body_entered.connect(_enter_trigger)
	my_interactable.body_exited.connect(_exit_trigger)
	my_interactable.area_shape_entered.connect(_enter_trigger)
	my_interactable.area_shape_exited.connect(_exit_trigger)
	my_interactable.body_shape_entered.connect(_enter_trigger)
	my_interactable.body_shape_exited.connect(_exit_trigger)




func _enter_trigger(triggering_body):
	pass

func _exit_trigger(triggering_body):
	pass

func _input_trigger(triggering_body):
	pass
