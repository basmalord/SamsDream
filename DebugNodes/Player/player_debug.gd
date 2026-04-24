extends DebugNode

class_name PlayerDebug

@export var debug_texture: Texture2D

func _ready() -> void:
	if !debug_mode:
		queue_free()
		return
	if debug_texture == null:
		push_error("ERROR: NO DEBUG TEXTURE SET TO PLAYER DEBUG SPRITE")
		return
	var sprite_node_container = Node2D.new()
	var sprite_node = Sprite2D.new()
	sprite_node_container.add_child(sprite_node)
	sprite_node_container.get_children()[0].texture = debug_texture
	add_child(sprite_node_container)
	print(sprite_node_container, sprite_node_container.get_parent(), sprite_node.get_parent())

func _physics_process(delta: float) -> void:
	if get_children().size() > 0:
		for child in get_children():
			child.global_position = get_parent().global_position
