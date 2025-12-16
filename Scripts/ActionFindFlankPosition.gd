class_name ActionFindFlankPosition
extends Action # Assuming you have a base Action class

@export var flank_distance: float = 5.0
@export var search_radius: float = 10.0
@export var target_key: String = "player_position"
@export var output_key: String = "flank_position"

func _execute(agent: Node, blackboard: Blackboard) -> int:
	var player_pos = blackboard.get_value(target_key)
	if player_pos == null:
		return FAILURE
	
	var agent_pos = agent.global_position # Or whatever property holds agent's position
	
	# Calculate a vector perpendicular to the agent-player vector
	var player_to_agent_vec = (agent_pos - player_pos).normalized()
	var flank_dir = player_to_agent_vec.rotated(deg_to_rad(90)) # Rotate 90 degrees
	
	# Try finding a valid position on the navigation mesh
	var potential_flank_pos = player_pos + (flank_dir * flank_distance)
	
	# Use Godot's NavigationServer2D/3D to find the closest point on the navmesh
	# For 2D:
	var nav_map = agent.get_world_2d().get_navigation_map()
	var closest_point = NavigationServer2D.map_get_closest_point(nav_map, potential_flank_pos)
	
	if closest_point:
		blackboard.set_value(output_key, closest_point)
		return SUCCESS
	
	return FAILURE
