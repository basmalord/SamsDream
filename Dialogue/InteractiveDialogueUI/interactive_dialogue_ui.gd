extends Control
@onready var output_box: Label = $OutputLineBox
@onready var input_line_controller: Control = $InputLineController
@onready var my_sprite: Sprite2D = $InteractiveDialogueSprite
@export var endemic_output_line: OutputLine 


func _end_dialogue():
	_destroy_input_buttons()
	output_box.text = ""
	hide()

func _destroy_input_buttons():
	var vbox = input_line_controller.get_children()[0]
	for child in vbox.get_children():
		child.queue_free()

func setup_from_output_line_resource(new_output_line: OutputLine):
	for child in input_line_controller.get_children()[0].get_children():
		child.queue_free()
	var output_id: String = new_output_line.id
	var resource_type = "OutputLine"
	var changes_dict = SaveManager.export_resource_saved_data(resource_type, output_id)
	if changes_dict != {}:
		var keys = changes_dict.keys()
		for key in keys:
			var new_value = changes_dict[key]
			new_output_line.set(key, new_value)
	output_box.text = new_output_line.text_array[0]
	for line in new_output_line.input_lines_id_array:
		var new_input_button: InputLineButton = InputLineButton.new()
		input_line_controller.get_child(0).add_child(new_input_button)
		var input_line_data_path: String = DataDirectoriesRegistry.get_file_path("InputLine", line)
		new_input_button.input_line_data = ResourceLoader.load(input_line_data_path)
		new_input_button._setup_data(self)
	if my_sprite.texture == new_output_line.portrait:
		return
	my_sprite.texture = new_output_line.portrait
