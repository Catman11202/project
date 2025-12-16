extends Node
class_name Blackboard

var data: Dictionary = {}

func set_value(key: String, value):
	data[key] = value

func get_value(key: String, default_value = null):
	return data.get(key, default_value)

func has_key(key: String) -> bool:
	return data.has(key)
