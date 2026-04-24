extends Node

@export var save_data: Dictionary 

var active_save: String = "user://Sams Game/saves/hello.tres"

func _import_change_to_save_data(data_type: String, id: String, property: String, value, resource_signal_name: String = ""):
	if !save_data.has(data_type):
		save_data[data_type] = {}
	if !save_data[data_type].has(id):
		save_data[data_type][id] = {}
	save_data[data_type][id][property] = value
	print(save_data)

func export_resource_saved_data(data_type: String, id: String) -> Dictionary:
	if save_data == null:
		return {}
	if !save_data.has(data_type):
		return {}
	if !save_data[data_type].has(id):
		return {}
	var result = save_data[data_type][id]
	return result

func set_active_save_data():
	var active_save_file = load(active_save)
	save_data = active_save_file.save_data
	print("THIS IS THE SAVE DATA: ", save_data)

func _generate_save_folder():
	var err = DirAccess.make_dir_recursive_absolute("user://Sams Game/saves/")
	if err != OK:
		push_error("Failed to create save directory: %s" % err)

func save_game(save_name: String = "") -> int:
	if save_name == "":
		push_error("Save Requires Name")
		return 0
	var save_game_path: String = GlobalDataDirectory.SAVE_GAMES_FOLDER_PATH + "/" + save_name + ".tres"
	var new_resource = SaveGame.new()
	_import_player_save_data()
	_import_scene_save_data()
	new_resource.save_data = save_data
	ResourceSaver.save(new_resource, save_game_path)
	return 1

func _import_player_save_data():
	if get_tree().get_first_node_in_group("player") != null:
		var player = get_tree().get_first_node_in_group("player")
		var player_position = player.global_position
		_import_change_to_save_data("player_data", "player", "globalpos", player_position)

func _import_scene_save_data():
	var scene_file_path: String = get_tree().current_scene.scene_file_path
	_import_change_to_save_data("scene_data", "1", "active_scene", scene_file_path)

func get_save_files() -> Array:
	var saves := []
	var save_files_directory = DataDirectoriesRegistry.SAVE_GAMES_FOLDER_PATH
	var dir = DirAccess.open(save_files_directory)
	if dir:
		var files = DirAccess.get_files_at(save_files_directory)
		for file in files:
			if file.ends_with(".tres"):
				saves.append(file)
	return saves

func _ready() -> void:
	_generate_save_folder()
	set_active_save_data()
