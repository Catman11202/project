class_name DialogueGraph extends Resource

@export var nodes: Array[DialogueNode] # All dialogue nodes in this graph
@export var start_node_id: String = "" # The ID of the first node to start the conversation

var _node_map: Dictionary = {}

func _init():
	if not Engine.is_editor_hint():
		_build_node_map()

func _build_node_map():
	_node_map.clear()
	for node in nodes:
		if not _node_map.has(node.id):
			_node_map[node.id] = node
		else:
			push_warning("Duplicate DialogueNode ID: " + node.id + " in DialogueGraph.")

func get_start_node() -> DialogueNode:
	if _node_map.is_empty():
		_build_node_map()
	return _node_map.get(start_node_id)

func get_node(node_id: String) -> DialogueNode:
	if _node_map.is_empty():
		_build_node_map()
	return _node_map.get(node_id)
