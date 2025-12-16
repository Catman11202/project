extends Node

signal dialogue_started(graph: DialogueGraph)
signal dialogue_ended()
signal line_displayed(text: String, character_name: String)
signal choices_available(choices: Array[DialogueChoice])
signal event_triggered(event_name: String)
signal dialogue_continue_requested()

var current_graph: DialogueGraph
var current_node: DialogueNode
var player_game_state: Dictionary = {} # Store player relevant data (e.g., has_gun, inventory)

func start_dialogue(graph: DialogueGraph, initial_player_state: Dictionary = {}):
	current_graph = graph
	player_game_state = initial_player_state
	current_node = current_graph.get_start_node()
	if current_node:
		emit_signal("dialogue_started", current_graph)
		_process_node()
	else:
		push_warning("DialogueGraph has no start node.")
		emit_signal("dialogue_ended")

func _process_node():
	if not current_node:
		emit_signal("dialogue_ended")
		return

	emit_signal("line_displayed", current_node.text, "") # Assuming no character name for now

	if current_node is DialogueChoiceNode:
		var available_choices = []
		for choice in (current_node as DialogueChoiceNode).choices:
			if choice.is_available(player_game_state):
				available_choices.append(choice)
		emit_signal("choices_available", available_choices)
	elif current_node is DialogueLineNode:
		# Wait for player input to continue for DialogueLineNode
		emit_signal("dialogue_continue_requested")
	elif current_node is DialogueConditionNode:
		var next_id = (current_node as DialogueConditionNode).get_next_node_id(player_game_state)
		current_node = current_graph.get_node(next_id)
		_process_node() # Immediately process next node after condition

func make_choice(choice_index: int):
	if current_node is DialogueChoiceNode:
		var choice = (current_node as DialogueChoiceNode).choices[choice_index]
		if not choice.event_signal_name.is_empty():
			emit_signal("event_triggered", choice.event_signal_name)
		current_node = current_graph.get_node(choice.next_node_id)
		_process_node()

func continue_dialogue():
	if current_node is DialogueLineNode:
		var next_id = (current_node as DialogueLineNode).get_next_node_id()
		current_node = current_graph.get_node(next_id)
		_process_node()
	else:
		push_warning("Cannot continue dialogue: Current node is not a DialogueLineNode or awaiting choice.")

func update_player_state(key: String, value: Variant):
	player_game_state[key] = value
