extends Node2D

class_name Room

@export var room_data: RoomData

func _ready() -> void:
	generate_background()
	generate_room_walls()
	generate_room_interactables()

func generate_background():
	print(room_data.room_background)

func generate_room_walls():
	print(room_data.room_walls)

func generate_room_interactables():
	print(room_data.room_interactables)
