class_name DialogueNode extends Resource

@export var id: String = ""
@export var text: String = "" # The dialogue text for this node

func _init(p_id: String = "", p_text: String = ""):
	id = p_id
	text = p_text

# This method will be overridden by specific node types
func get_next_node_id() -> String:
	return ""

func get_choices() -> Array[DialogueChoice]:
	return []
