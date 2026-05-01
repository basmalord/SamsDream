extends Node

signal fliers_changed

var fliers: int = 0

func _add_fliers(amount: int):
	fliers += amount
	emit_signal("fliers_changed")

func _set_fliers(amount: int):
	fliers = amount
	emit_signal("fliers_changed")

func get_fliers():
	return fliers
