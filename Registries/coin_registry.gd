extends Node

signal coins_changed

var coins: int = 0

func _add_coin(amount: int):
	coins += amount
	emit_signal("coins_changed")

func _set_coins(amount: int):
	coins = amount
	emit_signal("coins_changed")

func get_coins():
	return coins
