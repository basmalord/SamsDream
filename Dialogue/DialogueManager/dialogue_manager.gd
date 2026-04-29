extends Node

@onready var text_box_scene: PackedScene = preload("res://Dialogue/DialogueUI/text_box.tscn")

var dialogue_y_offset: int = 100
var dialogue_lines: Array[String] = []
var current_line_index: int = 0
var text_box 
var is_dialogue_active: bool = false
var can_advance_line: bool = false

func _ready():
	await get_tree().create_timer(0.5).timeout
	_set_text_box()


func start_dialogue(lines: Array[String], speaking_entity: Node):
	if is_dialogue_active:
		return
	dialogue_lines = lines
	text_box.global_position = speaking_entity.global_position
	text_box.global_position.y -= 100
	text_box.show()
	_show_text_box()
	is_dialogue_active = true

func _set_text_box(): #replace this with something that is able to find the given node and 
	text_box = text_box_scene.instantiate()
	var root = get_tree().root
	root.add_child(text_box)
	text_box.hide()
	text_box.connect("finished_displaying", _on_text_box_finished_displaying)

func get_dialogue_y_offset(speaking_entity: Node):
	if speaking_entity.get_parent() is Sprite2D:
		pass

func _show_text_box():
	text_box.display_text(dialogue_lines[current_line_index])
	can_advance_line = false

func _hide_text_box():
	text_box.hide()
	dialogue_lines = []
	current_line_index = 0
	is_dialogue_active = false
	can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true

func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ADVANCE_DIALOGUE"):
		#print(is_dialogue_active, can_advance_line)
	if(event.is_action_pressed("ADVANCE_DIALOGUE") && is_dialogue_active && can_advance_line):
		current_line_index += 1
		if current_line_index >= dialogue_lines.size():
			text_box.hide()
			is_dialogue_active = false
			current_line_index = 0
			return
		_show_text_box()
