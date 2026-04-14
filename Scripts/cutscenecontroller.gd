extends Node

@onready var player = $"../Player"
@onready var fade = $"../CanvasLayer/ColorRect"
@onready var narrator = $"../CanvasLayer/NarratorUI"
@onready var anim = $"Player/AnimatedSprite2D"

@export var pause_during_narration := true

var walking := false
var walk_speed := 120.0

func _ready():
	player.can_move = false

	# fade in
	fade.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, 1.2)
	tween.finished.connect(start_cutscene)


func start_cutscene():
	await play_narration(
		"Another long day scrubbing floors while heroes save the world."
	)

	await play_narration(
		"Well… \"heroes.\""
	)

	start_walk()

	await get_tree().create_timer(3.5).timeout

	await play_narration(
		"Incoming."
	)

	await get_tree().create_timer(0).timeout
	begin_exit()


func start_walk():
	walking = true
	anim.play("Walk")


func _process(delta):
	if walking:
		player.velocity.x = walk_speed
		player.velocity.y += player.gravity * delta
		player.move_and_slide()


func begin_exit():
	walking = false
	player.velocity = Vector2.ZERO

	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 1.2)
	tween.finished.connect(load_level)


func load_level():
	get_tree().change_scene_to_file("res://Levels/level_01_janitors_escape.tscn")


# -----------------------
# Narration helper
# -----------------------
func play_narration(text: String):
	if pause_during_narration:
		walking = false

	narrator.play_text(text)
	await narrator.narration_finished

	if pause_during_narration:
		walking = true
