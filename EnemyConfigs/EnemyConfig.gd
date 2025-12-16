class_name EnemyConfig extends Resource

@export_group("Basic Stats")
@export var enemy_name: String = "New Enemy"
@export_range(1, 1000, 1) var max_health: int = 100
@export_range(0.1, 20.0, 0.1) var movement_speed: float = 3.0
@export_range(1, 100, 1) var attack_damage: int = 10
@export_range(0.1, 5.0, 0.1) var attack_cooldown: float = 1.0 # Time between attacks

@export_group("Visuals & Audio")
@export var sprite_atlas: Texture2D # Main sprite atlas for animations
@export var death_sound: AudioStream # Sound played on death

@export_group("Behavior & AI")
@export var detection_range: float = 100.0 # How far the enemy can "see" the player
@export var chase_range: float = 200.0 # How far the enemy will chase
@export var aggression_level: float = 0.5 # 0.0 (passive) to 1.0 (very aggressive)
@export var unique_abilities: Array[String] # e.g., ["serum_injection", "flameball_throw"]

@export_group("Loot & Rewards")
@export var experience_given: int = 10 # XP awarded on defeat
@export var potential_drops: Array[Resource] # Array of Item resources this enemy can drop

# Optional: A reference to the enemy scene itself, if needed for instantiation
# @export var enemy_scene: PackedScene

func _init():
	pass # No special initialization needed here for a data-only resource
