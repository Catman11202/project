extends Node

signal game_state_changed(new_state)

# --- Game State Variables ---
var player_health: int = 100
var player_max_health: int = 100
var player_has_gun: bool = false
var player_has_bowie_knife: bool = false
var player_limp_active: bool = false
var infection_level: int = 0
var has_been_branded: bool = false

# --- Narrative Choice Variables ---
var cashier_encounter_choice: int = 0
var cashier_is_alive: bool = true
var took_cashier_pill: bool = false

# --- Inventory/Resource Tracking ---
var medkit_count: int = 0
var ammo_magazine_types: Dictionary = {"pistol_mag": 0, "shotgun_mag": 0}

# --- Game State Enum ---
enum GameState {
	TITLE_SCREEN,
	PLAYING,
	PAUSED,
	NARRATIVE_SEQUENCE,
	DREAM_STATE,
	CHOICE_MENU,
	GAME_OVER,
	LOADING
}

var current_state: GameState = GameState.TITLE_SCREEN

func _ready():
	print("GameManager initialized.")
	get_tree().connect("about_to_quit", Callable(self, "_on_about_to_quit"))
	get_tree().paused = false
	if SaveManager:
		SaveManager.load_game()
	set_game_state(GameState.TITLE_SCREEN)

# --- Player health & infection ---
func take_damage(amount: int):
	player_health = max(0, player_health - amount)
	if player_health <= 0:
		print("Player has died!")

func heal_player(amount: int):
	player_health = min(player_max_health, player_health + amount)

func advance_infection(amount: int = 1):
	infection_level += amount
	print("Infection level advanced to: %d" % infection_level)
	if infection_level >= 2:
		player_limp_active = true

# --- Narrative choices ---
func set_cashier_choice(choice_id: int):
	cashier_encounter_choice = choice_id
	cashier_is_alive = (choice_id != 2)
	print("Cashier choice: %d, alive: %s" % [choice_id, cashier_is_alive])

func _on_player_made_choice(choice_id: String, choice_result: String):
	if SaveManager:
		SaveManager.record_choice(choice_id, choice_result)
		SaveManager.save_game()

# --- Inventory handling ---
func add_item(item_name: String, count: int = 1):
	match item_name:
		"medkit":
			medkit_count += count
		"pistol_mag":
			ammo_magazine_types["pistol_mag"] += count
		"shotgun_mag":
			ammo_magazine_types["shotgun_mag"] += count
	print("Added %d %s(s)." % [count, item_name])

func use_item(item_name: String, count: int = 1) -> bool:
	match item_name:
		"medkit":
			if medkit_count >= count:
				medkit_count -= count
				return true
		"pistol_mag":
			if ammo_magazine_types["pistol_mag"] >= count:
				ammo_magazine_types["pistol_mag"] -= count
				return true
		"shotgun_mag":
			if ammo_magazine_types["shotgun_mag"] >= count:
				ammo_magazine_types["shotgun_mag"] -= count
				return true
	print("Failed to use %s. Not enough inventory." % item_name)
	return false

# --- Level / Scene handling ---
func _on_level_completed(next_level_name: String):
	if SaveManager:
		SaveManager.set_current_level(next_level_name)
		SaveManager.save_game()

# --- Pause menu / manual save ---
func _on_save_button_pressed():
	if SaveManager:
		SaveManager.save_game()

# --- Autosave on quit ---
func _on_about_to_quit():
	if SaveManager:
		SaveManager.save_game()
	print("Autosaved before quitting.")

# --- Game State Management ---
func set_game_state(new_state: GameState):
	if current_state == new_state:
		return
	var old_state = current_state
	current_state = new_state
	print("Game state changing from %s to %s" % [old_state, new_state])
	_exit_state(old_state)
	_enter_state(new_state)
	emit_signal("game_state_changed", new_state)

func _exit_state(state: GameState):
	match state:
		GameState.PLAYING:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		GameState.PAUSED:
			get_tree().paused = false
		GameState.NARRATIVE_SEQUENCE:
			Engine.time_scale = 1.0

func _enter_state(state: GameState):
	match state:
		GameState.TITLE_SCREEN:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = false
		GameState.PLAYING:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			get_tree().paused = false
		GameState.PAUSED:
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		GameState.NARRATIVE_SEQUENCE:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Engine.time_scale = 0.1
		GameState.DREAM_STATE:
			pass
		GameState.CHOICE_MENU:
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func toggle_pause():
	if current_state == GameState.PLAYING:
		set_game_state(GameState.PAUSED)
	elif current_state == GameState.PAUSED:
		set_game_state(GameState.PLAYING)

func start_game():
	if current_state == GameState.TITLE_SCREEN:
		set_game_state(GameState.PLAYING)

func trigger_narrative_event(event_id: String):
	if current_state in [GameState.PLAYING, GameState.NARRATIVE_SEQUENCE]:
		set_game_state(GameState.NARRATIVE_SEQUENCE)

func make_gas_station_choice(choice: String):
	if current_state == GameState.CHOICE_MENU:
		set_game_state(GameState.LOADING)
		match choice:
			"befriend":
				set_game_state(GameState.PLAYING)
			"shoot":
				set_game_state(GameState.PLAYING)
			_:
				printerr("Invalid choice made!")
