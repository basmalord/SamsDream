extends Node

class_name ChangeSpriteTrigger

var parent

func _ready() -> void:
	if get_parent() is Interactable2D:
		parent = get_parent()
