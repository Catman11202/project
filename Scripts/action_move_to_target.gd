class_name ActionMoveToTarget
extends BTAction

@export var speed: float = 100.0
@export var stop_distance: float = 10.0

func _execute() -> Status:
	if not agent or not blackboard.has("target_position"):
		return Status.FAILURE
	
	var current_pos: Vector2 = agent.global_position
	var target_pos: Vector2 = blackboard.target_position
	
	var direction: Vector2 = (target_pos - current_pos).normalized()
	var distance: float = current_pos.distance_to(target_pos)

	if distance <= stop_distance:
		# Target reached or close enough
		agent.velocity = Vector2.ZERO # Assuming agent has a velocity property
		#print(agent.name, " reached target.")
		return Status.SUCCESS
	
	# Move towards target
	agent.velocity = direction * speed # Assuming agent handles physics movement
	#print(agent.name, " moving towards ", target_pos, ". Distance: ", distance)
	
	return Status.RUNNING # Movement is ongoing

func exit():
	# Ensure the agent stops if this action is interrupted
	if agent and agent.has_method("stop_moving"): # A custom method on the agent
		agent.stop_moving()
	elif agent and agent.has_node("AnimationPlayer"): # Or stop animation
		agent.get_node("AnimationPlayer").stop()
