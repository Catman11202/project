class_name BTNode
extends RefCounted # Or Node if you prefer to visualize in editor, but RefCounted is lighter for logic nodes

enum Status { SUCCESS, FAILURE, RUNNING }

var children: Array[BTNode] = []
var parent: BTNode = null

func _init():
	pass # Can be used for custom initialization

# This method is the entry point for executing a node.
# It should be overridden by child classes.
func _execute() -> Status:
	# Default implementation, should be overridden.
	# In a real system, you might want to log a warning here if not overridden.
	print("Warning: _execute() not implemented for node: ", self.get_class())
	return Status.FAILURE

# Helper to add children to composite nodes
func add_child_node(node: BTNode):
	children.append(node)
	node.parent = self

# Called when the tree execution starts/resumes for this node.
# Useful for resetting internal state if needed (e.g., for selectors/sequences).
func enter():
	pass

# Called when the tree execution leaves this node.
# Useful for cleanup or state saving.
func exit():
	pass

# Optional: A reference to the AI agent this BT controls
var agent: Node = null

# Optional: A blackboard for sharing data between nodes
var blackboard: Dictionary = {}
