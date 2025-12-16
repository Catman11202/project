class_name Action
extends Resource  # Or Node if you want it in the scene tree

# Return codes for behavior tree actions
const SUCCESS: int = 1
const FAILURE: int = 2
const RUNNING: int = 3

# Optional reference to the agent and blackboard
var agent: Node
var blackboard: Dictionary

# Base execute function, meant to be overridden
func _execute(agent_ref: Node, blackboard_ref: Dictionary) -> int:
	agent = agent_ref
	blackboard = blackboard_ref
	return FAILURE  # Default does nothing
