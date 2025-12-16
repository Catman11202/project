# QuestData.gd
class_name QuestData
extends Resource

enum QuestState { NOT_STARTED, ACTIVE, COMPLETED, FAILED }

@export var id: String = ""
@export var quest_name: String = "New Quest"
@export_multiline var description: String = "Quest description here."
@export var current_state: QuestState = QuestState.NOT_STARTED
@export var objectives: Array[QuestObjectiveData] = []
@export var rewards: Array[QuestRewardData] = []
@export var prerequisite_quests: Array[String] = []
@export var on_completion_next_quest_id: String = ""
@export var on_choice_branch_quests: Dictionary = {}

func _init(p_id: String = "", p_name: String = ""):
	id = p_id
	quest_name = p_name

func is_completable() -> bool:
	for objective in objectives:
		if not objective.is_completed():
			return false
	return true

func reset():
	current_state = QuestState.NOT_STARTED
	for objective in objectives:
		objective.reset()

func get_progress_text() -> String:
	var completed_count = 0
	for objective in objectives:
		if objective.is_completed():
			completed_count += 1
	return "%d/%d objectives completed." % [completed_count, objectives.size()]
