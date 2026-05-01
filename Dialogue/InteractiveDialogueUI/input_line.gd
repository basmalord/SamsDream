extends Button

class_name InputLineButton

@export var input_line_data: InputLine 

var my_control: Control

func _handle_changes(target_input_line: InputLine):
	var changers_dict = target_input_line.changers_dict
	var ids: Array[String]
	for key in changers_dict.keys():
		ids.append(key)
	for id in ids:
		var changes_to_make: Dictionary = changers_dict[id]
		for key in changes_to_make.keys():
			var value = changes_to_make[key]
			match key:
				"transform":
					SaveManager._import_change_to_save_data("OutputLine", id, key, value)
				"is_dead":
					print("This is id: ", id, "this is vlaue: ", value)
					var spawner: Spawner2D
					spawner = get_tree().get_first_node_in_group("spawner")
					if !value:
						spawner._spawn_character(id)
					elif value:
						spawner._despawn_character(id)

func _setup_data(calling_node: Node):
	if input_line_data == null:
		push_error("inputline data not initialised")
		return
	var changes_dict = SaveManager.export_resource_saved_data(input_line_data.data_type, input_line_data.id)
	if changes_dict != {}:
		var keys = changes_dict.keys()
		for key in keys:
			var new_value = changes_dict[key]
			input_line_data.set(key, new_value)
	if input_line_data.said_before == true:
		modulate.a = 0.5
	text = input_line_data.text
	var index: int = 0
	for child in get_parent().get_children():
		index += 1
		if child == self:
			continue
	text = str(index) + ". " + text
	my_control = calling_node
	pressed.connect(_call_control)


func _call_control():
	if !input_line_data.said_before:
		print("this is all working baby")
		_handle_changes(input_line_data)
	if input_line_data.said_before == false:
		input_line_data.said_before = true
		SaveManager._import_change_to_save_data(input_line_data.data_type, input_line_data.id, "said_before", input_line_data.said_before)
	if input_line_data.end_dialogue == true:
		if my_control == null:
			return
		my_control._end_dialogue()
		return
	var output_line_resource_path = DataDirectoriesRegistry.get_file_path("OutputLine", input_line_data.output_line_id)
	var output_line_resource: OutputLine = load(output_line_resource_path)
	my_control.setup_from_output_line_resource(output_line_resource)
