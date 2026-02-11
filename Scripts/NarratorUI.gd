extends CanvasLayer

signal narration_finished

@export var typing_speed := 0.03
@export var use_typing_effect := true

@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label

var _full_text := ""
var _typing := false

func _ready():
	panel.visible = false

func play_text(text: String):
	panel.visible = true
	label.text = ""
	_full_text = text

	if use_typing_effect:
		_typing = true
		_type_text()
	else:
		label.text = text
		await _wait_for_continue()
		_finish()

func _type_text():
	for i in range(_full_text.length()):
		label.text += _full_text[i]
		await get_tree().create_timer(typing_speed).timeout

	_typing = false
	await _wait_for_continue()
	_finish()

func _wait_for_continue():
	while true:
		if Input.is_action_just_pressed("ui_accept"):
			return
		await get_tree().process_frame

func _finish():
	panel.visible = false
	narration_finished.emit()\
