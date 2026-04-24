extends Resource

class_name InteractableData

signal data_changed

var data_type: String = "InteractableData"
var active_state: String = "default"
var triggered: bool = false

@export var id: String:
	set(new_value):
		if id != new_value:
			id = new_value
			emit_signal("data_changed", data_type,  id, "id", id)
			emit_changed()
@export var state_textures: Dictionary [String, Texture2D] = {"default": Texture2D.new(), "altered": Texture2D.new()}:
	set(new_value):
		if state_textures != new_value:
			state_textures = new_value
			emit_signal("data_changed", data_type,  id, "id", id)
			emit_changed()
@export var multi_interact: bool = false:
	set(new_value):
		if multi_interact != new_value:
			multi_interact = new_value
			emit_signal("data_changed", data_type,  id, "id", id)
			emit_changed()
@export var states: Array[String] = ["default", "altered"]:
	set(new_value):
		if states != new_value:
			states = new_value
			emit_signal("data_changed", data_type,  id, "id", id)
			emit_changed()
