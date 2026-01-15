extends CharacterBody2D

@export var throw_interval := 2.0
@export var paper_scene: PackedScene

func _ready():
	throw_paper_loop()

func throw_paper_loop():
	while true:
		await get_tree().create_timer(throw_interval).timeout
		throw_paper()

func throw_paper():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var paper = paper_scene.instantiate()
	paper.global_position = $ThrowPoint.global_position

	var aim_direction = (player.global_position - paper.global_position).normalized()
	paper.direction = aim_direction

	get_parent().add_child(paper)
