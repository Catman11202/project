class_name ConditionIsPlayerVisible
extends BTCondition

@export var sight_range: float = 300.0
@export var field_of_view_angle: float = 60.0 # Degrees

func _execute() -> Status:
	if not agent or not blackboard.player:
		return Status.FAILURE
	
	var player = blackboard.player
	var agent_pos = agent.global_position
	var player_pos = player.global_position

	# Distance check
	if agent_pos.distance_to(player_pos) > sight_range:
		return Status.FAILURE

	# Facing direction
	var agent_forward = Vector2(1, 0)
	if agent.has_method("get_facing_direction"):
		agent_forward = agent.get_facing_direction()

	var to_player = (player_pos - agent_pos).normalized()
	var angle_to_player = rad_to_deg(agent_forward.angle_to(to_player))

	if abs(angle_to_player) > field_of_view_angle / 2.0:
		return Status.FAILURE

	# Line of sight
	var space_state = agent.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.new()
	query.from = agent_pos
	query.to = player_pos
	query.exclude = [agent]
	query.collision_mask = 1 | 2  # 1 = world, 2 = player (replace with your layers)

	var result = space_state.intersect_ray(query)

	if result.empty() or result.collider == player:
		blackboard.target_position = player_pos
		return Status.SUCCESS

	return Status.FAILURE
