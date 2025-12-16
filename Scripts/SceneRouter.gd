extends Node

# Signals
signal scene_transition_started(new_scene_path)
signal scene_transition_finished(new_scene_path)
signal scene_transition_failed(new_scene_path, error_message)

# Internal state
var _current_scene_path: String = ""
const LOADING_SCREEN_PATH: String = "res://Scenes/UI/LoadingScreen.tscn"
var _loading_screen_instance: Node = null
var _target_scene_path: String = ""

func _ready() -> void:
	_current_scene_path = get_tree().current_scene.scene_file_path if get_tree().current_scene else ""
	print("SceneRouter initialized. Current scene: ", _current_scene_path)

func goto_scene(path: String, with_loading_screen: bool = true) -> void:
	if path == _current_scene_path:
		print("Already in scene: ", path)
		return

	_target_scene_path = path
	emit_signal("scene_transition_started", _target_scene_path)

	if with_loading_screen and ResourceLoader.exists(LOADING_SCREEN_PATH):
		var loading_screen_scene = load(LOADING_SCREEN_PATH)
		if loading_screen_scene:
			_loading_screen_instance = loading_screen_scene.instantiate()
			get_tree().root.add_child(_loading_screen_instance)
			# Assume the loading screen emits 'loading_screen_ready' when ready
			_loading_screen_instance.connect("loading_screen_ready", Callable(self, "_on_loading_screen_ready"), CONNECT_ONE_SHOT)
			# Hide the current scene while loading
			if get_tree().current_scene:
				get_tree().current_scene.visible = false
		else:
			printerr("Failed to load loading screen: ", LOADING_SCREEN_PATH)
			_load_scene_internal(_target_scene_path)
	else:
		_load_scene_internal(_target_scene_path)

func _on_loading_screen_ready() -> void:
	_load_scene_internal(_target_scene_path)

func _load_scene_internal(path: String) -> void:
	var error = get_tree().change_scene_to_file(path)
	if error != OK:
		var error_msg = "Failed to load scene: %s (Error code: %d)" % [path, error]
		printerr(error_msg)
		emit_signal("scene_transition_failed", path, error_msg)
		_cleanup_loading_screen()
		return

	_current_scene_path = path
	print("Successfully transitioned to scene: ", path)
	emit_signal("scene_transition_finished", path)
	_cleanup_loading_screen()

func _cleanup_loading_screen() -> void:
	if is_instance_valid(_loading_screen_instance):
		_loading_screen_instance.queue_free()
		_loading_screen_instance = null

	# Make the new scene visible if it was hidden
	if get_tree().current_scene and not get_tree().current_scene.visible:
		get_tree().current_scene.visible = true

func get_current_scene_path() -> String:
	return _current_scene_path
