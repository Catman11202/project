class_name QuestObjectiveData
extends Resource

enum ObjectiveType { KILL_ENEMIES, COLLECT_ITEM, REACH_LOCATION, INTERACT_NPC, MAKE_CHOICE, SURVIVE_TIMER }

@export var type: ObjectiveType
@export var description: String = ""
@export var target_id: String = "" # e.g., enemy_type_id, item_id, location_node_path, NPC_id
@export var target_count: int = 1 # For kill/collect objectives
@export var current_progress: int = 0
@export var is_optional: bool = false

@export var _is_completed: bool = false

func is_completed() -> bool:
	return _is_completed

func complete():
	_is_completed = true

func reset():
	current_progress = 0
	_is_completed = false

func increment_progress(amount: int = 1):
	if _is_completed:
		return
	current_progress += amount
	if current_progress >= target_count:
		_is_completed = true
