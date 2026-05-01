extends Node2D

class_name Spawner2D #behaviour should be call_spawn(id), call_despawn(id)

var character_scene_dict: Dictionary[String, String]
var character_global_position_dict: Dictionary[String, Vector2]
var character_dead_dict: Dictionary[String, bool]
var spawner_save_data_available: bool = false

func _ready() -> void:
	call_save_data_manager()
	if !spawner_save_data_available:
		_populate_character_scene_dict()
		SaveManager.save_data["spawner"] = {}
		SaveManager.save_data["spawner"]["character_scene_dict"] = character_scene_dict
		SaveManager.save_data["spawner"]["character_global_position_dict"] = character_global_position_dict
		SaveManager.save_data["spawner"]["character_dead_dict"] = character_dead_dict
		_initiate_characters()
		return
	SaveManager.save_data["spawner"]["character_dead_dict"] = character_dead_dict
	_initiate_characters()
	print(character_dead_dict)


func _initiate_characters():
	print("init characters")
	var ids: Array[String]
	ids = SaveManager.save_data["spawner"]["character_dead_dict"].keys()
	for id in ids:
		print("init character: ", id)
		var death_state: bool = SaveManager.save_data["spawner"]["character_dead_dict"][id]
		print(death_state)
		if death_state == false:
			_despawn_character(id)
		elif death_state == true:
			var has_child: bool = false
			for child in get_children():
				if child.my_data.id == id:
					has_child = true
			if !has_child:
				_spawn_character(id)

func call_save_data_manager():
	if SaveManager.active_save == "" or SaveManager.active_save == null:
		spawner_save_data_available = false
		return
	if !SaveManager.save_data.has("spawner"):
		print("spawner data not here, spawner")
		spawner_save_data_available = false
		return
	if !SaveManager.save_data["spawner"].has("scene_dict"):
		print("spawner data not here, scene")
		spawner_save_data_available = false
		return
	if !SaveManager.save_data["spawner"].has("position_dict"):
		print("spawner data not here, pos")
		spawner_save_data_available = false
		return
	if !SaveManager.save_data["spawner"].has("character_dead_dict"):
		print("spawner data not here, dead")
		spawner_save_data_available = false
		return
	spawner_save_data_available = true
	character_scene_dict = SaveManager.save_data["spawner"]["scene_dict"]
	character_global_position_dict = SaveManager.save_data["spawner"]["position_dict"]
	character_dead_dict = SaveManager.save_data["spawner"]["character_dead_dict"]

func _save_character_spawn(id: String, is_not_dead: bool):
	if !SaveManager.save_data.has("spawner"):
		SaveManager.save_data["spawner"] = {}
	if !SaveManager.save_data["spawner"].has("character_dead_dict"):
		SaveManager.save_data["spawner"]["character_dead_dict"] = {}
	if !SaveManager.save_data["spawner"]["character_dead_dict"].has(id):
		SaveManager.save_data["spawner"]["character_dead_dict"][id] = {}
	SaveManager.save_data["spawner"]["character_dead_dict"][id] = is_not_dead
	print("this is dead dict from saver: ", character_dead_dict)

func _spawn_character(id: String):
	print("SPAWNER_CALLED")
	var character_scene_path = character_scene_dict[id]
	var new_character = load(character_scene_path).instantiate() 
	add_child(new_character)
	var new_position: Vector2 = character_global_position_dict[id]
	new_character.global_position = new_position
	_save_character_spawn(id, true)

func _despawn_character(id: String):
	print("DESPAWNER_CALLED")
	if character_dead_dict.keys().find(id) == -1:
		push_error("ERROR: DESPAWNER CALLED BUT NO DATA ON ID")
		return
	for child in get_children():
		if child is not Interactable2D:
			continue
		if child.my_data.id == id:
			child.queue_free()
			_save_character_spawn(id, false)
			return

func _populate_character_scene_dict():
	if get_children() == []:
		return
	var scenes: Array[String]
	var death_states: Array[bool]
	var ids: Array[String]
	for child in get_children():
		if child is Interactable2D:
			var scene_path = child.get_scene_file_path()
			scenes.append(scene_path)
			death_states.append(child.my_data.initial_state)
			var id: String = child.my_data.id
			ids.append(id)
			character_global_position_dict[id] = child.global_position
	var index: int = 0
	for id in ids:
		character_scene_dict[id] = scenes[index]
		index += 1
	index = 0
	for id in ids:
		character_dead_dict[id] = death_states[index]
		index += 1
