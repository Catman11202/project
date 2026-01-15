extends Area2D

var speed := 200.0
var direction := Vector2.ZERO
var thrown_by_player := false
var can_be_caught := true


func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)


func _physics_process(delta):
	position += direction * speed * delta


func reverse(dir: Vector2):
	direction = dir


func _on_body_entered(body):

	# Player gets hurt ONLY by enemy throws
	if body.is_in_group("player") and not thrown_by_player:
		_show_hit_text("Ouch!", body.global_position)
		queue_free()

	# Enemy gets hurt ONLY by player throws
	elif body.is_in_group("enemy") and thrown_by_player:
		_show_hit_text("Hit!", body.global_position)

	# Tell the player we scored a hit
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.register_enemy_hit()

		queue_free()



func _on_area_entered(area):

	# Ignore CatchArea completely
	if area.is_in_group("catch_area"):
		return


func _show_hit_text(text:String, pos:Vector2):
	var label := Label.new()
	label.text = text
	label.global_position = pos
	get_tree().current_scene.add_child(label)

	var tween := get_tree().create_tween()
	tween.tween_property(label, "position:y", label.position.y - 20, 0.6)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.6)
	tween.tween_callback(label.queue_free)
