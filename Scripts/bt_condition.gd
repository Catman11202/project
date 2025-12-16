class_name BTCondition
extends BTNode

# Override this in your specific condition classes
func _execute() -> Status:
	print("Warning: Condition _execute() not implemented for node: ", self.get_class())
	return Status.FAILURE
