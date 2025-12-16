class_name ZombieAI
extends CharacterBody2D

@export var bt_root_path: NodePath

var bt_root
var blackboard: Dictionary = {}

func _ready():
	if bt_root_path != NodePath(""):
		bt_root = get_node(bt_root_path)
		if bt_root and bt_root is BTNode:
			_initialize_bt(bt_root)
		else:
			print("Error: Node at path is not a BTNode!")
	else:
		print("Warning: No BT root path assigned to ", name)

	# Store player in blackboard for Resource-based conditions
	var player = get_tree().get_first_node_in_group("player")
	if player:
		blackboard.player = player

func _initialize_bt(node: BTNode):
	node.agent = self
	node.blackboard = blackboard
	for child in node.get_children():
		if child is BTNode:
			_initialize_bt(child)

func _physics_process(delta):
	if bt_root:
		bt_root._execute()
	move_and_slide()  # Godot 4: velocity is automatically used

func get_facing_direction() -> Vector2:
	if $Sprite2D.scale.x < 0:
		return Vector2(-1, 0)
	return Vector2(1, 0)

func stop_moving():
	velocity = Vector2.ZERO  # Use built-in velocity
