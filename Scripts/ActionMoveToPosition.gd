class_name ActionMoveToPosition
extends Action

@export var position_key: String = "target_position"
@export var speed: float = 100.0

func _execute(agent_ref: Node, blackboard_ref: Dictionary) -> int:
	# Assign references from base class
	agent = agent_ref
	blackboard = blackboard_ref

	var target_pos = blackboard.get(position_key, null)
	if target_pos == null:
		return FAILURE
	
	var agent_pos = agent.global_position
	var direction = (target_pos - agent_pos).normalized()
	
	var nav_agent = agent.get_node_or_null("NavigationAgent2D")
	if nav_agent:
		nav_agent.target_position = target_pos
		var next_path_pos = nav_agent.get_next_path_position()
		agent.velocity = (next_path_pos - agent_pos).normalized() * speed
		agent.move_and_slide()
		
		if agent_pos.distance_to(target_pos) < nav_agent.path_desired_distance:
			return SUCCESS
		else:
			return RUNNING
	
	return FAILURE
