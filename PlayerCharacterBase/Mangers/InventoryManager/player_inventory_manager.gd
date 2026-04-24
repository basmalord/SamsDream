extends Node

class_name PlayerInventoryManager

var my_player: Node

@export var inventory_data: Dictionary [String, bool]

func _ready():
	my_player = get_parent()
	_update_inventory("bootros")

func _update_inventory(item: String, add_item: bool = true):
	match add_item: 
		true:
			_add_inventory_item(item)
		false:
			_remove_inventory_item(item)
	if my_player == null:
		return
	my_player.ui_manager._update_inventory_ui(inventory_data)
	print("working")

func _remove_inventory_item(item: String):
	inventory_data.erase(item)

func _add_inventory_item(item: String):
	inventory_data[item] = true
