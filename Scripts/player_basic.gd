extends CharacterBody2D

@export var speed := 200.0
@export var jump_force := -350.0
@export var gravity := 900.0

@onready var catch_area: Area2D = $CatchArea
@onready var held_anchor: Node2D = $HeldItemAnchor
#@onready var anim = $Sprite2D

var held_paper: Area2D = null
var overlapping_paper: Area2D = null
var enemy_hits := 0
var hits_required := 5

func _trigger_next_cutscene():
	get_tree().change_scene_to_file("res://Scenes/Cutscene_End.tscn")

func _ready():
	catch_area.area_entered.connect(_on_paper_entered)
	catch_area.area_exited.connect(_on_paper_exited)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed

	# Jump
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_force

	move_and_slide()

	#_update_animation(direction)

func _input(event):
	if event.is_action_pressed("interact") and overlapping_paper and held_paper == null:
		catch_paper(overlapping_paper)
		overlapping_paper = null
	elif event.is_action_pressed("interact") and held_paper:
		throw_paper()

func _on_paper_entered(area):
	if area.has_method("reverse") and area.can_be_caught:
		overlapping_paper = area

func _on_paper_exited(area):
	if area == overlapping_paper:
		overlapping_paper = null

func catch_paper(paper):
	held_paper = paper
	paper.can_be_caught = false
	paper.speed = 0
	paper.set_deferred("monitoring", false)

	paper.get_parent().remove_child(paper)
	held_anchor.add_child(paper)
	paper.position = Vector2.ZERO

func throw_paper():
	var paper = held_paper
	held_paper = null

	# detach from player
	held_anchor.remove_child(paper)
	get_parent().add_child(paper)
	paper.global_position = held_anchor.global_position

	# IMPORTANT: re-enable movement
	paper.thrown_by_player = true
	paper.speed = 400
	paper.monitoring = true
	paper.can_be_caught = false

	# aim at enemy
	var enemy = get_tree().get_first_node_in_group("enemy")
	if enemy:
		var dir = (enemy.global_position - paper.global_position).normalized()
		paper.reverse(dir)
	else:
		paper.reverse(Vector2.RIGHT)
func register_enemy_hit():
	enemy_hits += 1
	print("Enemy hit count:", enemy_hits)

	if enemy_hits >= hits_required:
		_trigger_next_cutscene()

'''
func _update_animation(direction):
	# Handle flipping
	if direction != 0:
		$AnimatedSprite2D.flip_h = direction < 0

	# Air animations
	if not is_on_floor():
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")
		return

	# Ground animations
	if direction == 0:
		anim.play("idle")
	else:
		anim.play("walk")
'''
