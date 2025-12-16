class_name BTSequence
extends BTNode

var current_child_index: int = 0

func _execute() -> Status:
	for i in range(current_child_index, children.size()):
		var child = children[i]
		var status = child._execute()

		match status:
			Status.SUCCESS:
				# Continue to the next child in the sequence
				pass
			Status.RUNNING:
				current_child_index = i # Remember which child is running
				return Status.RUNNING
			Status.FAILURE:
				current_child_index = 0 # Reset for next tick
				return Status.FAILURE

	current_child_index = 0 # All children succeeded, reset for next tick
	return Status.SUCCESS

func enter():
	current_child_index = 0 # Reset when sequence first starts

func exit():
	# Optionally reset children's state if they had running status
	pass
