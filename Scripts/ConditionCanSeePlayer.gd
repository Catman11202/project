class_name ConditionCanSeePlayer
extends Condition # Assuming a base Condition class

@export var player_node_path: NodePath # Path to the player node

func _evaluate(agent: Node, blackboard: Blackboard) -> bool:
	var player_node = get_node(player_node_path)
	if !player_node:
		return false
	
	var space_state = agent.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.new()
	query.from = agent.global_position
	query.to = player_node.global_position
	query.collide_with_areas = true # Adjust as needed
	query.collide_with_bodies = true
	query.exclude = [agent] # Don't hit self
	
	var result = space_state.intersect_ray(query)
	
	if result.empty():
		return false # No hit, but also no player hit if something else is in the way
	
	# Check if the hit object is the player
	if result.collider == player_node:
		blackboard.set_value("player_position", player_node.global_position)
		return true
	
	return false
