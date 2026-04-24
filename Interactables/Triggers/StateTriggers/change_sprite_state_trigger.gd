extends Node

class_name StateChangeTextureTrigger

@export var state_texture_dict: Dictionary[String, Texture2D]
var parent: Node


func _ready() -> void:
	if get_parent() is not Interactable2D:
		return
	parent = get_parent()
	state_texture_dict = parent.my_data.state_textures

func _state_changed(state: String):
	if state_texture_dict.keys().find(state) == -1:
		return
	var new_texture = state_texture_dict[state]
	print("this is parent + texture before = new text: ", parent, " + ", parent.sprite.texture)
	parent.sprite.texture = new_texture
