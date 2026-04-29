extends Control
@onready var output_box: TextBox = $TextBox
@onready var input_line_controller: Control = $InputLineController
@onready var my_sprite: Sprite2D = $InteractiveDialogueSprite
@export var endemic_output_line: OutputLine 

var input_line_font: Font = preload("res://fonts/ModernDOS9x16.ttf")
var dialogue_lines: Array
var is_dialogue_active: bool = false
var can_advance_line: bool = false
var current_line_index: int = 0
var input_options_array: Array[String]

const CHARACTER_LIMIT: int = 58
const ACCEPTABLE_ENDS: Array[String] = [" ", ".", ",", "!", "?"]


func _ready() -> void:
	output_box.connect("finished_displaying", _on_text_box_finished_displaying)

func _on_text_box_finished_displaying():
	can_advance_line = true
	if current_line_index >= dialogue_lines.size() - 1:
		print("THIS WORKED")
		_present_input_options(input_options_array)


func _end_dialogue():
	_destroy_input_buttons()
	output_box.text = ""
	dialogue_lines = []
	current_line_index = 0
	is_dialogue_active = false
	can_advance_line = false
	hide()

func _destroy_input_buttons():
	var vbox = input_line_controller.get_children()[0]
	for child in vbox.get_children():
		child.queue_free()

func setup_from_output_line_resource(new_output_line: OutputLine):
	for child in input_line_controller.get_children()[0].vbox_container.get_children():
		child.queue_free()
	var output_id: String = new_output_line.id
	var resource_type = "OutputLine"
	var changes_dict = SaveManager.export_resource_saved_data(resource_type, output_id)
	if changes_dict != {}:
		var keys = changes_dict.keys()
		for key in keys:
			var new_value = changes_dict[key]
			new_output_line.set(key, new_value)
	current_line_index = 0
	dialogue_lines = generate_text_array(new_output_line.text_array[0])
	_present_output_text()
	is_dialogue_active = true
	input_options_array = new_output_line.input_lines_id_array
	if my_sprite.texture == new_output_line.portrait:
		return
	my_sprite.texture = new_output_line.portrait

func _present_input_options(input_options: Array[String]):
	for line in input_options:
		var new_input_button: InputLineButton = InputLineButton.new()
		var scroll_container = input_line_controller.get_child(0)
		scroll_container.vbox_container.add_child(new_input_button)
		var input_line_data_path: String = DataDirectoriesRegistry.get_file_path("InputLine", line)
		new_input_button.input_line_data = ResourceLoader.load(input_line_data_path)
		new_input_button.add_theme_font_override("font", input_line_font)
		new_input_button.flat = true
		new_input_button.add_theme_color_override("font_color", Color(0.0, 0.0, 0.0, 1.0))
		new_input_button.add_theme_font_size_override("font_size", 16)
		new_input_button.size_flags_horizontal = scroll_container.SIZE_EXPAND_FILL
		new_input_button.size_flags_vertical = scroll_container.SIZE_EXPAND_FILL
		new_input_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		print("1: ", new_input_button.size)
		new_input_button.autowrap_mode = TextServer.AUTOWRAP_WORD
		print("2: ", new_input_button.size)
		new_input_button._setup_data(self)

func _present_output_text():
	print("this is dialogue lines: ", dialogue_lines)
	output_box.display_text(dialogue_lines[current_line_index])
	can_advance_line = false

func generate_text_array(line: String) -> Array[String]:
	var line_length = line.length()
	var line_to_append: String
	var index: int = 0
	var lines_array: Array[String]
	while index < line_length:
		if line_to_append.length() == CHARACTER_LIMIT or index == line_length - 1:
			if !_has_acceptable_end_character(line_to_append, ACCEPTABLE_ENDS):
				var difference: int
				difference = endify_string(line_to_append)[1]
				line_to_append = endify_string(line_to_append)[0]
				var difference_string: String = ""
				for i in range(difference):
					difference_string += " "
					index -= 1
				line_to_append += difference_string
			lines_array.append(line_to_append)
			line_to_append = ""
		line_to_append += line[index]
		index += 1
		if index == line_length:
			var last = lines_array.size() - 1
			var adjusted_index: int = index - 1
			lines_array[last] += line[adjusted_index]
	return lines_array

func endify_string(text: String):
	var original_length: int = text.length()
	var original_text: String = text
	while !_has_acceptable_end_character(text, ACCEPTABLE_ENDS):
		if text.length() == 0:
			return [original_text, 0]
		text = text.erase(text.length() -1)
	var difference = original_length - text.length()
	return [text, difference]

func _has_acceptable_end_character(text: String, endings: Array[String]):
	for end in endings:
		if text.ends_with(end):
			return true
	return false

func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ADVANCE_DIALOGUE"):
		#print(is_dialogue_active, can_advance_line)
	if(event.is_action_pressed("ADVANCE_DIALOGUE") && is_dialogue_active && can_advance_line):
		current_line_index += 1
		if current_line_index >= dialogue_lines.size():
			return
		_present_output_text()
