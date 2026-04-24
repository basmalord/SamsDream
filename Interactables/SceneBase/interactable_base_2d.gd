extends Area2D

class_name Interactable2D

@onready var sprite: Sprite2D = $InteractableSprite

@export var my_data: InteractableData

var state_tracker: StateTracker


func _ready() -> void:
	var changes_dict = SaveManager.export_resource_saved_data(my_data.data_type, my_data.id)
	if changes_dict != {}:
		var keys = changes_dict.keys()
		for key in keys:
			var new_value = changes_dict[key]
			my_data.set(key, new_value)
	_state_changed(my_data.active_state)

func _register_state_tracker(tracker_node: StateTracker):
	state_tracker = tracker_node


func _state_changed(state: String):
	print("THIS HAS FIRED")
	for child in get_children():
		if child.has_method("_state_changed"):
			print("this is child: ", child)
			child._state_changed(state)
