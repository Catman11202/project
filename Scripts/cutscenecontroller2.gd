extends Node

@onready var player = $"../Player"
@onready var fade = $"../CanvasLayer/ColorRect"

var walking := false
var walk_speed := 120.0

func _ready():
	# disable player control
	player.can_move = false

	# fade in from black
	fade.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, 1.2)

	# start walking after fade
	tween.finished.connect(start_walk)


func start_walk():
	walking = true

	# narrator line (optional)
	# print("As a janitor, you step into the firehouse...")

	# after 3.5 sec → fade out
	var timer = get_tree().create_timer(3.5)
	timer.timeout.connect(begin_exit)


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
	get_tree().change_scene_to_file("res://Levels/level_02_gf_house.tscn")
