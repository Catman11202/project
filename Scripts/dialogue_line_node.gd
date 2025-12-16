class_name DialogueLineNode extends DialogueNode

@export var next_node_id: String = "" # The ID of the next node to proceed to

func _init(p_id: String = "", p_text: String = "", p_next_node_id: String = ""):
	super(p_id, p_text)
	next_node_id = p_next_node_id

func get_next_node_id() -> String:
	return next_node_id
