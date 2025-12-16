class_name DialogueChoiceNode extends DialogueNode

@export var choices: Array[DialogueChoice]

func _init(p_id: String = "", p_text: String = "", p_choices: Array[DialogueChoice] = []) :
	super(p_id, p_text)
	choices = p_choices

func get_choices() -> Array[DialogueChoice]:
	return choices

func get_next_node_id() -> String:
	# Choice nodes don't have a single next_node_id; player choice determines it.
	return ""
