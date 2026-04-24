extends Node

class_name PlayerMovementManager

var my_player: Node = null

var current_direction: String = "none"
var current_inputs: Array[String] = []
var should_move = true

const PLAYER_MOVEMENT_INPUTS := ["MOVE_FORWARD", "MOVE_BACKWARDS", "MOVE_RIGHT", "MOVE_LEFT"]
const ORIGINAL_SPEED := 50
const SPRINT_MODIFIER := Vector2(2,2)

func _ready():
	await get_tree().create_timer(0.5).timeout
	var parent = get_parent()
	var player = parent.my_player
	player.input_manager.connect("world_state_entered",Callable(self, "_set_should_move"))
	player.input_manager.connect("ui_state_entered",Callable(self, "_set_should_move"))

func _set_should_move():
	if should_move == true:
		should_move = false
	elif should_move == false:
		should_move = true

func get_input_direction() -> Vector2:
	if should_move == true:
		if my_player == null:
			my_player.behaviour_manager.animation_manager.pause()
			print("mplayer null")
			return Vector2(0,0)
		if my_player.input_manager.current_pressed_inputs.size() == 0:
			my_player.behaviour_manager.animation_manager.pause()
			return Vector2(0,0)
		var current_player_direction = my_player.input_manager.current_pressed_inputs[0]
		if current_player_direction == "SPRINT":
			if my_player.input_manager.current_pressed_inputs.size() == 1:
				return Vector2(0,0)
			current_player_direction = my_player.input_manager.current_pressed_inputs[1]
		var direction = Vector2(0,0)
		match current_player_direction:
			"MOVE_FORWARD":
				direction = Vector2(0,-1)
				my_player.behaviour_manager.animation_manager.play(current_player_direction)
			"MOVE_BACKWARDS":
				direction = Vector2(0,1)
				my_player.behaviour_manager.animation_manager.play(current_player_direction)
			"MOVE_RIGHT":
				direction = Vector2(1,0)
				my_player.behaviour_manager.animation_manager.play("MOVE_SIDEWAYS")
			"MOVE_LEFT":
				direction = Vector2(-1,0)
				my_player.behaviour_manager.animation_manager.play("MOVE_SIDEWAYS", true)
		return direction
	else:
		var direction := Vector2(0,0)
		my_player.behaviour_manager.animation_manager.pause()
		return direction

func append_inputs(input: String):
	current_inputs.append(input)
	set_current_direction(current_inputs[0])

func remove_input(input: String):
	var input_index = current_inputs.find(input)
	current_inputs.remove_at(input_index)
	set_current_direction(current_inputs[0])

func call_animation_manager():
	var animation_to_set: String = get_current_direction()
	get_parent().set_animation()

func get_current_direction():
	current_direction = current_inputs[0]

func set_current_direction(direction: String):
	if direction == current_direction:
		return
	current_direction = direction

func set_player_velocity() -> Vector2:
	var player_velocity = get_input_direction() * ORIGINAL_SPEED
	return player_velocity

func get_sprint_modifier():
	if Input.is_action_pressed("SPRINT"):
		return SPRINT_MODIFIER
	else:
		return Vector2(1,1)
