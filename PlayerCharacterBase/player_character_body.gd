extends CharacterBody2D

class_name PlayerCharacter

const MANAGERS := ["behaviour", "logic", "ui", "input", "inventory"]

@onready var behaviour_manager: PlayerCharacterBehaviourManager = create_new_manager("behaviour")
@onready var logic_manager: PlayerCharacterLogicManager = create_new_manager("logic")
@onready var ui_manager: PlayerCharacterUIManager = create_new_manager("ui")
@onready var input_manager: PlayerInputManager = create_new_manager("input")
@onready var inventory_manager: PlayerInventoryManager = create_new_manager("inventory")
@onready var dialogue_text_box = $PlayerUI/DialogueUI/TextBox
@onready var animated_sprite = $PlayerCharacterAnimatedSprite
@onready var interactive_dialogue = $InteractiveDialogueUi

func _ready():
	await get_tree().create_timer(1)
	if !SaveManager.save_data.has("player_data"):
		return
	global_position = SaveManager.save_data["player_data"]["player"]["globalpos"]


#PROCESS_FUNCTION

func _physics_process(delta: float) -> void:
	velocity = behaviour_manager.movement_manager.set_player_velocity() * behaviour_manager.movement_manager.get_sprint_modifier()
	move_and_slide()


#NODE_CREATORS

func create_new_manager(manager_type: String):
	if MANAGERS.find(manager_type) == -1:
		push_error("Attempted to create unkown player manager: ", manager_type)
		return
	var new_manager
	match manager_type:
		"behaviour":
			new_manager = PlayerCharacterBehaviourManager.new()
		"logic":
			new_manager = PlayerCharacterLogicManager.new()
		"ui":
			new_manager = PlayerCharacterUIManager.new()
		"input":
			new_manager = PlayerInputManager.new()
		"inventory":
			new_manager = PlayerInventoryManager.new()
		_:
			return
	add_child(new_manager)
	new_manager.my_player = self
	return new_manager

func _set_interact_ray_rotation(animation_name: String, flipped: bool):
	if animation_name == "MOVE_FORWARD":
		$InteractCastArea/InteractCastBox.rotation_degrees = 180
	elif animation_name == "MOVE_BACKWARDS":
		$InteractCastArea/InteractCastBox.rotation_degrees = 0
	elif animation_name == "MOVE_SIDEWAYS":
		if !flipped:
			$InteractCastArea/InteractCastBox.rotation_degrees = -90
		else:
			$InteractCastArea/InteractCastBox.rotation_degrees = 90
