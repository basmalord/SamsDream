extends Control


func _on_save_game_button_pressed() -> void:
	if SaveManager.save_game($SaveGameNameInput.text) == 0:
		$SaveGameNameInput.text = "Save Requires Name"


func _on_load_game_button_pressed() -> void:
	pass


func _on_back_button_pressed() -> void:
	hide()


func _on_load_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://UtilityMenus/load_menu.tscn")
