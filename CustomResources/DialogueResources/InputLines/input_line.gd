extends Resource

class_name InputLine

signal data_changed(resource_type: String, resource_id: String, property_name: String, value)

var data_type: String = "InputLine"

@export var id: String:
	set(new_value):
		if id != new_value:
			id = new_value
			emit_signal("data_changed", data_type, id, "id", id)
			emit_changed()
@export var output_line_id: String:
	set(new_value):
		if output_line_id != new_value:
			output_line_id = new_value
			emit_signal("data_changed", data_type,  id, "output_line_id", output_line_id)
			emit_changed()
@export var text: String:
	set(new_value):
		if text != new_value:
			text = new_value
			emit_signal("data_changed", data_type,  id, "text", text)
			emit_changed()
@export var end_dialogue: bool = false:
	set(new_value): 
		if end_dialogue != new_value:
			end_dialogue = new_value
			emit_signal("data_changed", data_type,  id, "end_dialogue", end_dialogue)
			emit_changed()
var said_before: bool = false:
	set(new_value):
		if said_before != new_value:
			said_before = new_value
			emit_signal("data_changed", data_type,  id, "said_before", said_before)
			emit_changed()
@export var changers_dict: Dictionary[String, Dictionary]:
	set(new_value):
		if changers_dict != new_value:
			changers_dict = new_value
			emit_signal("data_changed", data_type,  id, "changers_dcit", changers_dict)
			emit_changed()
