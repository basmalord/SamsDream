extends Resource

class_name OutputLine

signal data_changed(resource_type: String, resource_id: String, property_name: String, value)

var data_type: String = "OutputLine"
var fired: bool = false

@export var id: String:
	set(new_value):
		if id != new_value:
			id = new_value
			emit_signal("data_changed", data_type,  id, "id", id)
			emit_changed()
@export var input_lines_id_array: Array[String]:
	set(new_value):
		if input_lines_id_array != new_value:
			input_lines_id_array = new_value
			emit_signal("data_changed", data_type,  id, "input_lines_id_array", input_lines_id_array)
			emit_changed()
@export var portrait: Texture2D:
	set(new_value):
		if portrait != new_value:
			portrait = new_value
			emit_signal("data_changed", data_type,  id, "portrait", portrait)
			emit_changed()
@export var text_array: Array[String]:
	set(new_value):
		if text_array != new_value:
			text_array = new_value
			emit_signal("data_changed", data_type,  id, "text_array", text_array)
			emit_changed()
@export var changers_dict: Dictionary[String, Dictionary]:
	set(new_value):
		if changers_dict != new_value:
			changers_dict = new_value
			emit_signal("data_changed", data_type,  id, "changers_dcit", changers_dict)
			emit_changed()
@export var end_dialogue: bool = false:
	set(new_value): 
		if end_dialogue != new_value:
			end_dialogue = new_value
			emit_signal("data_changed", data_type,  id, "end_dialogue", end_dialogue)
			emit_changed()
