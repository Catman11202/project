class_name BTAction
extends BTNode

# Override this in your specific action classes
func _execute() -> Status:
	print("Warning: Action _execute() not implemented for node: ", self.get_class())
	return Status.FAILURE
