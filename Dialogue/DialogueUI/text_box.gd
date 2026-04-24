extends MarginContainer

class_name TextBox

const MAX_WIDTH: int = 64

@onready var text_box_label = $MarginContainer/Label
@onready var text_box_timer = $LetterDisplayTimer

@export var letter_time: float = 0.03
@export var space_time: float = 0.06
@export var punctuation_time: float = 0.2
@export var text: String
var letter_index: int = 0

signal finished_displaying()

func display_text(text_to_display: String):
	text = text_to_display
	text_box_label.text = text_to_display
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	if size.x > MAX_WIDTH:
		text_box_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_box_label.text = ""
	_display_letter()

func _display_letter():
	text_box_label.text += text[letter_index]
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		letter_index = 0
		return
	match text[letter_index]:
		"!", ".", ",","?":
			text_box_timer.start(punctuation_time)
		" ":
			text_box_timer.start(space_time)
		_:
			text_box_timer.start(letter_time)


func _on_letter_display_timer_timeout() -> void:
	_display_letter()
