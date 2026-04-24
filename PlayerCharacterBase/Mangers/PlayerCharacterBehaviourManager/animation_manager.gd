extends Node

class_name PlayerAnimationManager

var my_player: Node

@export var animation_set: Dictionary = {"forward": "enter animation path",
"backward": "enter animation path", "sides": "enter animation path"}

var active_animation: String

func play(animation_to_play: String, flipped: bool = false):
	var player = get_parent().get_parent()
	player._set_interact_ray_rotation(animation_to_play, flipped)
	player.animated_sprite.play(animation_to_play)
	if !flipped:
		player.animated_sprite.flip_h = false
	if flipped:
		player.animated_sprite.flip_h = true

func pause():
	var player = get_parent().get_parent()
	player.animated_sprite.pause()
