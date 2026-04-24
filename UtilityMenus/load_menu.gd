extends Control

@onready var load_list_container = $LoadListContainer

var selected: String = ""

func _ready():
	_populate_load_list_container()

func _populate_load_list_container():
	print("LURKIN")
	load_list_container.clear()
	var saves = SaveManager.get_save_files()
	print("SHURKIN")
	if saves.size() == 0:
		return
	for save in saves:
		var display_name: String = save.trim_suffix(".tres")
		load_list_container.add_item(display_name)
		load_list_container.set_item_metadata(load_list_container.get_item_count() - 1, save)

func get_selected_save_path() -> String:
	selected = load_list_container.get_item_text(load_list_container.get_selected_id())
	return "user://Sams Game/saves/" + selected + ".tres"


func _on_load_button_pressed() -> void:
	SaveManager.active_save = get_selected_save_path()
	SaveManager.set_active_save_data()
	if SaveManager.save_data["scene_data"]["1"]["active_scene"] == null:
		get_tree().change_scene_to_file("res://TestScenes/test_scene.tscn")
		return
	var active_scene_file_path: String = SaveManager.save_data["scene_data"]["1"]["active_scene"]
	get_tree().change_scene_to_file(active_scene_file_path)
