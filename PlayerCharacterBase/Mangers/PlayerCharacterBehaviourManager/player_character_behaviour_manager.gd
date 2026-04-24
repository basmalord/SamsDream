extends Node

class_name PlayerCharacterBehaviourManager

var my_player: PlayerCharacter
@onready var movement_manager: PlayerMovementManager = PlayerMovementManager.new()
@onready var animation_manager: PlayerAnimationManager = PlayerAnimationManager.new()

func _ready():
	my_player = get_parent()
	add_child(movement_manager)
	add_child(animation_manager)
	for child in get_children():
		var property_list = child.get_property_list()
		var property_name_list: Array[String]
		for entry in property_list:
			property_name_list.append(entry["name"])
		if property_name_list.has("my_player"):
			child.my_player = my_player 
			print(child.my_player)


func set_animation(animation: String): #need to make a singal that checks whenever a velocity changes past x point or whether and input changes and then matches the animation
	animation_manager.play(animation)
