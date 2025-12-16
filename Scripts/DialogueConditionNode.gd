class_name DialogueConditionNode extends DialogueNode

@export var condition_script: String = "" # Path to a script that defines a condition function
@export var true_node_id: String = "" # Node to go to if condition is true
@export var false_node_id: String = "" # Node to go to if condition is false

func _init(p_id: String = "", p_condition_script: String = "", p_true_node_id: String = "", p_false_node_id: String = ""):
	super(p_id, "") # Condition nodes typically don't have text
	condition_script = p_condition_script
	true_node_id = p_true_node_id
	false_node_id = p_false_node_id

func evaluate_condition(player_data: Dictionary) -> bool:
	if condition_script.is_empty():
		push_warning("ConditionNode '" + id + "' has no condition_script.")
		return false
	var condition_func = load(condition_script).new().evaluate
	return condition_func.call(player_data)

func get_next_node_id(player_data: Dictionary = {}) -> String:
	if evaluate_condition(player_data):
		return true_node_id
	else:
		return false_node_id
