extends Node

class_name GlobalDataDirectory

const SAVE_GAMES_FOLDER_PATH: String = "user://Sams Game/saves/"
const data_directories_dict: Dictionary[String,String] = {"InputLine": "res://CustomResourceInstances/InputLines/",
"OutputLine": "res://CustomResourceInstances/OutputLines/"}

var current_save_folder: String
var save_specific_data_directories_dict: Dictionary[String, String]

func get_file_path(data_type: String, file_ID: String) -> String:
	var data_directory: String = data_directories_dict[data_type]
	var file_path: String = data_directory + file_ID + ".tres"
	return file_path

func get_resource_type(resource: Resource) -> String:
	var script: Script = resource.get_script()
	if script == null:
		return ""
	var resource_name: String = script.get_global_name()
	return resource_name

func _set_save_directory(save_name: String):
	current_save_folder = SAVE_GAMES_FOLDER_PATH + save_name
