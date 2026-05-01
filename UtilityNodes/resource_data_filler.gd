extends Control

var active_dir: String

func _ready() -> void:
	pass

func save_all_resource_ids():
	var suffix: String = ".tres"
	var dir = DirAccess.open("res://CustomResourceInstances/OutputLines/")
	var dir_path = "res://CustomResourceInstances/OutputLines/"
	var file_names = dir.get_files()
	for file_name in file_names:
		var file_path: String = dir_path + file_name
		var id_name: String = file_name.trim_suffix(".tres")
		var res: Resource = ResourceLoader.load(file_path)
		res.id = id_name
		ResourceSaver.save(res, file_path)
	dir = DirAccess.open("res://CustomResourceInstances/InputLines/")
	dir_path = "res://CustomResourceInstances/InputLines/"
	file_names = dir.get_files()
	for file_name in file_names:
		var file_path: String = dir_path + file_name
		var id_name: String = file_name.trim_suffix(".tres")
		var res: Resource = ResourceLoader.load(file_path)
		res.id = id_name
		ResourceSaver.save(res, file_path)

func _populate_options(new_type: int):
	if new_type == 0:
		active_dir = "res://CustomResourceInstances/OutputLines/"
	else:
		active_dir = "res://CustomResourceInstances/InputLines/"
	var dir = DirAccess.open(active_dir)
	var file_names = dir.get_files()
	for file_name in file_names:
		$OptionButton.add_item(file_name)


func _on_button_pressed() -> void:
	var id = $OptionButton.get_selected_id()
	var index = $OptionButton.get_item_index(id)
	var file_name = $OptionButton.get_item_text(index)
	var text = $LineEdit.text
	var dir = DirAccess.open(active_dir)
	var file_path = active_dir + file_name
	var resource = ResourceLoader.load(file_path)
	if resource is OutputLine:
		resource.text_array.append(text)
	if resource is InputLine:
		resource.text = text
	ResourceSaver.save(resource, file_path)
