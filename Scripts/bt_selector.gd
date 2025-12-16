class_name BTSelector
extends BTNode

var current_child_index: int = 0

func _execute() -> Status:
	for i in range(current_child_index, children.size()):
		var child = children[i]
		var status = child._execute()

		match status:
			Status.SUCCESS:
				current_child_index = 0 # Reset for next tick
				return Status.SUCCESS
			Status.RUNNING:
				current_child_index = i # Remember which child is running
				return Status.RUNNING
			Status.FAILURE:
				# Continue to the next child
				pass
	
	current_child_index = 0 # All children failed, reset for next tick
	return Status.FAILURE

func enter():
	current_child_index = 0 # Reset when selector first starts

func exit():
	# Optionally reset children's state if they had running status
	pass
