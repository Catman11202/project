class_name DialogueChoice extends Resource

@export var choice_text: String = ""
@export var next_node_id: String = "" # The ID of the node to jump to if this choice is made
@export var condition_script: String = "" # Path to a script that defines a condition function (optional)
@export var event_signal_name: String = "" # A signal to emit when this choice is selected (optional)

func _init(p_choice_text: String = "", p_next_node_id: String = ""):
	choice_text = p_choice_text
	next_node_id = p_next_node_id

func is_available(player_data: Dictionary) -> bool:
	if condition_script.is_empty():
		return true
	var condition_func = load(condition_script).new().can_choose
	return condition_func.call(player_data)
