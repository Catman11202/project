extends Node

const SAVE_FILE_NAME: String = "user://deadrise_save.json"

# --- Game data dictionary ---
var game_data: Dictionary = {
	"current_level": "Level 1",
	"player_position": Vector2.ZERO,
	"player_health": 100,
	"inventory": [], # List of item names or IDs
	"choices": {},   # Narrative choices
	"infection_stage": 0,
	"has_bowie_knife": false,
	"has_enhanced_loadout": false,
	"equipped_outfit": "janitor_uniform",
	"story_flags": {}, # Generic flags for story progression
}

func _ready() -> void:
	# Ensure the "user://" directory exists
	var dir: DirAccess = DirAccess.open("user://")
	if dir == null:
		# Directory doesn't exist, create it using a temporary DirAccess instance
		var tmp_dir: DirAccess = DirAccess.open("res://")
		if tmp_dir:
			var err: int = tmp_dir.make_dir_recursive("user://")
			if err != OK:
				printerr("Failed to create save directory: user://")
			tmp_dir.close()
	
	# Reopen the user:// directory to confirm
	dir = DirAccess.open("user://")
	load_game()

# --- Save game ---
func save_game() -> void:
	var file: FileAccess = FileAccess.open(SAVE_FILE_NAME, FileAccess.WRITE)
	if not file:
		printerr("Failed to open save file for writing: ", SAVE_FILE_NAME)
		return
	file.store_string(JSON.stringify(game_data, "\t")) # Pretty-print
	file.close()
	print("Game Saved Successfully!")

# --- Load game ---
func load_game() -> void:
	if not FileAccess.file_exists(SAVE_FILE_NAME):
		print("No save file found. Starting new game.")
		_reset_game_data_to_defaults()
		return

	var file: FileAccess = FileAccess.open(SAVE_FILE_NAME, FileAccess.READ)
	if not file:
		printerr("Failed to open save file for reading: ", SAVE_FILE_NAME)
		_reset_game_data_to_defaults()
		return

	var content: String = file.get_as_text()
	file.close()

	var parsed_data = JSON.parse_string(content)
	if parsed_data.error == OK:
		for key in game_data.keys():
			if parsed_data.result.has(key):
				game_data[key] = parsed_data.result[key]
		print("Game Loaded Successfully!")
	else:
		printerr("Failed to parse save file: ", parsed_data.error_string)
		_reset_game_data_to_defaults()

# --- Reset game data to defaults ---
func _reset_game_data_to_defaults() -> void:
	game_data = {
		"current_level": "Level 1",
		"player_position": Vector2.ZERO,
		"player_health": 100,
		"inventory": [],
		"choices": {},
		"infection_stage": 0,
		"has_bowie_knife": false,
		"has_enhanced_loadout": false,
		"equipped_outfit": "janitor_uniform",
		"story_flags": {},
	}
	print("Game data reset to defaults.")

# --- Helper setters ---
func set_current_level(level_name: String) -> void:
	game_data["current_level"] = level_name

func set_player_health(health: int) -> void:
	game_data["player_health"] = health

func add_to_inventory(item_id: String) -> void:
	if not item_id in game_data["inventory"]:
		game_data["inventory"].append(item_id)

func record_choice(choice_key: String, choice_value: String) -> void:
	game_data["choices"][choice_key] = choice_value

func set_infection_stage(stage: int) -> void:
	game_data["infection_stage"] = stage

func set_story_flag(flag_key: String, value: bool) -> void:
	game_data["story_flags"][flag_key] = value

# --- Helper getters ---
func get_current_level() -> String:
	return game_data["current_level"]

func get_player_health() -> int:
	return game_data["player_health"]

func get_inventory() -> Array:
	return game_data["inventory"]

func get_choice(choice_key: String) -> String:
	return game_data["choices"].get(choice_key, "")

func get_infection_stage() -> int:
	return game_data["infection_stage"]

func get_story_flag(flag_key: String) -> bool:
	return game_data["story_flags"].get(flag_key, false)
